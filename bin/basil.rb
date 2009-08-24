#! /usr/bin/env ruby
# == Synopsis
# Crawls a site starting at the given URL, and outputs the total number
#
# == Usage
# basil create [search_name] [url]
# basil run [search_name]
#
# == Author
# Kyle Banker 
 
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
 
require 'basilisk'
 
def usage
  puts <<END


basil(isk): a front-end for the anemone web crawler.
Usage: 

  To create a new search: 
    basil create [search_name] [url]

      - This will create a search config file, which you may edit to change the default options.

  To run the search:
    basil run [search_name]

      - Runs the specified search. Note: you must create a search before running it.
END
end
 
begin
  if ARGV[0] == "create" && ARGV[1] && URI(ARGV[2])
    Basilisk.create(ARGV[1], ARGV[2])
  elsif ARGV[0] == "run" && !ARGV[1].nil?
    Basilisk.run(File.join(Dir.pwd, ARGV[1]))
  else
    raise BasiliskArgumentError
  end

rescue BasiliskArgumentError
  usage
  Process.exit
end
