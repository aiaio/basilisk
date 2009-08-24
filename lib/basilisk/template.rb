module Basilisk
  module Template 
    extend self

    def default(options={})
      yaml = <<-CONFIG
# This is a basilisk config file.
# Available processors include the following:
#   seo: generates a csv with the following columns: url, title, description, keywords, h1s, h2s
#   sitemap: generates an xml sitemap
#   error: generates a csv of urls returning html response codes other than success and redirect.
#
# Separate processors with a semi-colon:
#   processors: "seo; sitemap"
# Separate regex terms with a semi-colon:
#   regex_search_terms: "error\w+;invalid\w+"
# Separate css terms with a semi-colon:
#   css_search_terms: "#error_message; .error"
# Regex patterns separated with semi-colons
#   skip_url_patterns: "[0-9]+;some silly expression\s+;"
# Optionally specify a user agent:
#   user_agent: "sneaky-crawler"

basilisk:
  name: "#{options[:name]}"
  url: "#{options[:url]}"
  processors: "seo; sitemap; error"
  regex_search_terms: ""
  css_search_terms: ""
  skip_url_patterns: ""
  user_agent: "anemone-basilisk"
      CONFIG
    end

    def output_instructions(search_name, filename, foldername)
      instruction = <<-INSTRUCTIONS

You just created the following search: #{search_name}

If you'd like to change the default options, edit the file #{filename}

To run your search:

  basil run #{search_name}

Your search results will appear in #{foldername}

      INSTRUCTIONS
      puts instruction
    end

  end
end
