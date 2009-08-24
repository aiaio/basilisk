require 'basilisk/processor'

module Basilisk
  module Core
    extend self

    # Takes search options and runs the crawler with any processors.
    def run(search_opts)

      # We need to close the processors if user presses ctrl-c.
      trap("INT") do 
        puts "\n**Interrupt received**\n***Closing processors...\n"
        close_processors(search_opts.processor_instances)
        Process.exit
      end

      Anemone.crawl(search_opts.url, :user_agent => search_opts.user_agent, :verbose => true) do |anemone|
        anemone.skip_links_like(search_opts.skip_patterns || [])

        # At least one search processor must be specified.
        anemone.on_every_page do |page|
          search_opts.processor_instances.each do |processor|
            processor.process_page(page, anemone.pages)
          end
        end

        # Close callback on all processors.
        anemone.after_crawl do |pages|
          close_processors(search_opts.processor_instances)
        end

      end
    end

    def close_processors(instances)
      instances.each do |processor|
        processor.close_file
      end
    end

    # Create a folder for the processor results, 
    # and a default yaml config file in the current directory.
    def create(search_name, url)
      filename   = create_config_file(search_name, url, filename)
      foldername = create_results_folder(search_name)

      Basilisk::Template.output_instructions(search_name, filename, foldername)
      rescue => e
        puts "Error: Could not create config file or folder."
        puts "Please make sure that a folder of the same name doesn't already exist.\n"
        puts "(#{e})"
    end

    def create_config_file(search_name, url, filename)
      filename = File.join(Dir.pwd, search_name + ".yml")
      file     = File.open(filename, "w")
      file.write(Basilisk::Template.default(:name => search_name, :url => url))
      file.close
      return filename
    end

    def create_results_folder(search_name)
      foldername = File.join(Dir.pwd, search_name)
      Dir.mkdir(foldername)
      return foldername
    end

  end
end
