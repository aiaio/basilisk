module Basilisk
  # Base class for page processors.
  class Processor

    def initialize(search_name)
      @search_name   = search_name
      @base_folder   = Dir.pwd
      @output_folder = File.join(Dir.pwd, search_name)
    end

    def process_page(page, page_hash)
    end
    
    # Called when the crawl is completed.
    def close_file
    end

    protected

    def filename_for_output
      File.join @output_folder, 
        self.class.name.sub("Processor", "").sub("Basilisk::", "").downcase + ".csv"
    end

    def write_file(&block)
      file = File.open(filename_for_output, "a")
      yield file
      file.close
    end

  end

  # Processors that outputs a csv should inherit from this class.
  class CSVProcessor < Processor

    def write_file(&block)
      FasterCSV.open(filename_for_output, "a") do |csv|
        yield csv
      end
    end

  end
end
