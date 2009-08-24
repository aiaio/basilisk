module Basilisk
  # Stores page errors.
  class TermsProcessor < Basilisk::CSVProcessor

    def initialize(search_name, regex_terms, css_terms)
      super(search_name)
      @regex_terms = regex_terms
      @css_terms   = css_terms
      save_header_row
    end

    def process_page(page, page_hash)
      regexes   = match_regexes(page.doc)
      css_terms = match_css_terms(page.doc) 
      write_row(page, regexes, css_terms) if !regexes.empty? || !css_terms.empty?
    end

    private

    def filename_for_output
      File.join @output_folder, @search_name + "-terms.csv"
    end

    def save_header_row
      write_file do |csv|
        csv << ["URL", "Regex Terms", "CSS Terms"]
      end
    end

    def write_row(page, regexes, css_terms)
      write_file do |csv|
        csv << [page.url, regexes.map {|r| r.source }.join(';'), css_terms.join(';')]
      end
    end

    def match_regexes(doc)
      @regex_terms.select do |term|
        doc.to_s =~ term
      end
    end
    
    def match_css_terms(doc)
      @css_terms.select do |term|
        doc.css(term)
      end
    end

  end
end
