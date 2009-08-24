module Basilisk
  # Build a google-compatible xml sitemap for the crawled site.
  class SitemapProcessor < Basilisk::Processor

    def initialize(search_name)
      super
      @date = Time.now.strftime("%Y-%m-%d")
      save_header
    end

    def process_page(page, page_hash)
      write_url(page)
    end

    def close_file
      write_file do |file|
        file.write "</urlset>\n"
      end
    end

    private

    def filename_for_output
      File.join @output_folder, @search_name + "-sitemap.xml"
    end

    def save_header
      write_file do |file|
        file.write "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        file.write "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n"
      end
    end

    def write_url(page)
      write_file do |file|
      file.write "<url>\n"
      file.write "  <loc>#{page.url}</loc>\n"
      file.write "  <lastmod>#{@date}></lastmod>\n"
      file.write "  <changefreq>monthly</changefreq>\n"
      file.write "  <priority>#{priority(page.url)}</priority>\n"
      file.write "</url>\n"
     end 
    end

    # Assigns a default priority of 1.0 to 0.1 based on page depth.
    def priority(url)
      level = 1.0 - ((url.to_s.split("/").size - 3) / 10.0)
      level < 0.1 ? 0.1 : level 
    end

  end
end
