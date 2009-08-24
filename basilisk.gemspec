# -*- encoding: utf-8 -*-
 
 Gem::Specification.new do |s|
  s.name = "basilisk"
  s.version = "0.2"
  s.authors = ["Kyle Banker", "Alexander Interactive, Inc."]
  s.date = "2009-08-24"
  s.summary = "A command-line front-end for the anemone web-spider. Generates reports for seo, http errors and an xml sitemap. Extensible page handler."
  s.homepage = "http://github.com/aiaio/basilisk"
  s.email = "knb@alexanderinteractive.com"
  s.files = ["HISTORY", "LICENSE", "README", "bin/basil.rb", "lib/basilisk.rb", "lib/basilisk/core.rb", "lib/basilisk/parser.rb", "lib/basilisk/processor.rb", "lib/basilisk/template.rb", "lib/basilisk/processors/error_processor.rb", "lib/basilisk/processors/seo_processor.rb", "lib/basilisk/processors/terms_processor.rb", "lib/basilisk/processors/sitemap_processor.rb"]
  s.require_paths = ["lib"]
  s.executables = ["basil.rb"]
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
  s.rdoc_options = ["--main", "README"]
  s.add_dependency("nokogiri", [">= 1.3.0"])
  s.add_dependency("anemone", [">= 0.1.2"])
end
