module Basilisk
  # Stores page errors.
  class ErrorProcessor < Basilisk::CSVProcessor

    def initialize(search_name)
      super
      save_header_row
    end

    def process_page(page, page_hash)
      write_row(page, page_hash) if page.code != 200 && !page.redirect?
    end

    private

    def filename_for_output
      File.join @output_folder, @search_name + "-errors.csv"
    end

    def save_header_row
      write_file do |csv|
        csv << ["URL", "Error"]
      end
    end

    def write_row(page, page_hash)
      write_file do |file|
        file << [page.url, page.code]
      end
    end

  end
end
