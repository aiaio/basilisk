module Basilisk
  # Parses YAML config file and instantiates specified processor classes.
  module Parser
    extend self

    def get_options(opt_file)
      yaml_opts         = open_yaml_file(opt_file)
      search_opts       = assign_options(yaml_opts)
      validate_options(search_opts)
      return search_opts
    end

    private

    def open_yaml_file(filename)
      filename += ".yml" unless filename.include?(".yml")
      YAML::parse(File.open(filename))
    end

    def assign_options(yaml_opts)
      search_opts               = OpenStruct.new
      search_opts.name          = yaml_opts['basilisk']['name'].value
      search_opts.url           = yaml_opts['basilisk']['url'].value
      search_opts.user_agent    = yaml_opts['basilisk']['user_agent'].value
      search_opts.skip_patterns = get_patterns(yaml_opts['basilisk']['skip_url_patterns'].value)
      search_opts.processor_instances   = 
        instantiate_processors(yaml_opts['basilisk']['processors'].value, search_opts.name)

      search_opts.regex_search_terms   = get_patterns(yaml_opts['basilisk']['regex_search_terms'].value)
      search_opts.css_search_terms     = split_and_strip(yaml_opts['basilisk']['css_search_terms'].value, ";")
      search_opts.processor_instances  << init_term_processor(search_opts) if search_has_terms?(search_opts)
      return search_opts
    end

    def validate_options(search_opts)
      return true
    end

    def instantiate_processors(processors, search_name)
      split_and_strip(processors, ";").map do |name| 
        get_processor_class(name).new(search_name)
      end
    end

    # Returns an array of case-insensitive regexps.
    def get_patterns(pattern_string)
      split_and_strip(pattern_string, ";").select do |name|
        name != ""
      end.map {|name| Regexp.new(name, true)}
    end

    def split_and_strip(collection, separator)
      collection.split(separator).map {|item| item.strip }
    end

    def get_processor_class(name)
      Module.const_get("Basilisk").const_get(name.capitalize + "Processor")
    end

    def search_has_terms?(opts)
      !opts.regex_search_terms.empty? || !opts.css_search_terms.empty?
    end

    def init_term_processor(opts)
      Basilisk::TermsProcessor.new(opts.name, opts.regex_search_terms, opts.css_search_terms)
    end

  end
end
