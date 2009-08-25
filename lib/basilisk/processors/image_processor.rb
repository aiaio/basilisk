require 'net/http'
require 'uri'

module Basilisk
  # Generates a report for broken images and images missing alt tags.
  class ImageProcessor < Basilisk::CSVProcessor

    def initialize(search_name)
      super
      save_header_row
      @image_url_cache = []
    end

    def process_page(page, page_hash)
      return unless page.doc
      begin
        page.doc.css('img').each do |image|
          begin
          image_src = image['src']
          absolute_image_url = image_url(page, image_src)
          next if @image_url_cache.include?(absolute_image_url)
          @image_url_cache << absolute_image_url

          check_for_broken_image(page, absolute_image_url)
          check_for_missing_alt_tag(page, image, absolute_image_url)

        rescue BasiliskImageError => e
          write_row(page, image['src'], e.message)
        end
      end
      end
    end

    private

    def check_for_broken_image(page, absolute_image_src)
      http_status = image_http_status(absolute_image_src)
      if http_status != "200"
        write_row(page, absolute_image_src, "Image broken (#{http_status})")
      end
    end

    def check_for_missing_alt_tag(page, image, absolute_image_src)
      return unless image['alt']
      image_alt = image['alt'].strip
      if image_alt == ""   
        write_row(page, absolute_image_src, "Alt tag missing")
      end
    end

    # Perform a head request on the image so we won't have to download it. 
    def image_http_status(uri)
      puts "Requesting Image: #{uri}"
      http     = Net::HTTP.new(uri.host, uri.port)
      response = http.head(uri.path)
      return response.code
      rescue
        return "500"
    end

    # Construct the image's absolute url, if necessary.
    def image_url(page, image_src)
      image_uri = URI.parse(image_src)
      if image_uri.absolute?
        image_uri
      elsif image_uri.relative?
        root     = URI::Generic.build :scheme => page.url.scheme, :host => page.url.host 
        URI.join root.to_s, image_uri.to_s
      else
        raise BasiliskImageError, "Could not parse image src."
      end
      rescue
        raise BasiliskImageError, "Could not parse image src."
    end

    def filename_for_output
      File.join @output_folder, @search_name + "-images.csv"
    end

    def save_header_row
      write_file do |csv|
        csv << ["Page URL", "Image URL", "Message"]
      end
    end

    def write_row(page, image_url, message)
      write_file do |file|
        file << [page.url, image_url, message]
      end
    end

  end
end
