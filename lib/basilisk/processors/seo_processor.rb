module Basilisk
  # Write a csv containing important seo fields: title, h1, h2, description, and keywords.
  class SeoProcessor < Basilisk::CSVProcessor
    HTMLTags = ['title', 'h1', 'h2']
    MetaTags = ['description', 'keywords']

    def initialize(search_name)
      super
      save_header_row
    end

    def process_page(page, page_hash)
      @tags = Hash.new("")
      HTMLTags.each { |tag_name|  check_html_element(tag_name, page.doc) }
      MetaTags.each { |meta_name| check_meta_element(meta_name, page.doc) }
      save_tag_row(page)
    end

    private

    # Take a tag name (:h1, :title) and an hpricot doc.
    # Stores the number of occurrences of the element
    # along with its content.
    def check_html_element(name, doc)
      elements = doc.css(name)
      process_tag(name, elements, "text")
    end

    # Take a meta name (:description, keywords) and an hpricot doc.
    # Stores the number of occurrences of the element
    # along with its content.
    def check_meta_element(name, doc)
      elements = doc.css("meta[@name='#{name}']") 
      process_tag(name, elements, ["[]", "content"])
    end

    # Code that processes an array of nokogiri elements
    # by formatting them and saving to the @tags hash.
    def process_tag(name, elements, content_method)
      (@tags[name] += "MISSING") && return if elements.empty?
      @tags[name]  += "(#{elements.size}): " if elements.size > 1
      elements.each do |e|
        content     = e.send(*content_method)
        text_to_add = content == "" ? "BLANK" : "#{content}"
        text_to_add = add_parentheses(text_to_add) if elements.size > 1
        @tags[name] += text_to_add
      end
      @tags[name].strip!
    end

    def save_header_row
      write_file do |csv|
        csv << ["URL", HTMLTags, MetaTags].flatten
      end
    end

    def save_tag_row(page)
      row = []
      row << page.url.to_s
      [HTMLTags, MetaTags].flatten.each do |tag_key|
        row << @tags[tag_key]
      end

      write_file do |csv|
        csv << row 
      end
    end

    def add_parentheses(text)
      "(#{text}) "
    end

  end
end
