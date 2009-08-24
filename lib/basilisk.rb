require 'ostruct'
require 'yaml'

require 'rubygems'
require 'anemone'
require 'fastercsv'

require 'basilisk/core'
require 'basilisk/parser'
require 'basilisk/processor'
require 'basilisk/template'

$:.unshift File.join(File.dirname(__FILE__), 'basilisk', 'processors')
require 'seo_processor'
require 'sitemap_processor'
require 'error_processor'
require 'terms_processor'

BASILISK_ROOT = File.join(File.dirname(__FILE__), "..")

class BasiliskError < StandardError; end
class BasiliskArgumentError < BasiliskError; end

module Basilisk
  extend self

  def run(opt_file)
    Basilisk::Core.run(Basilisk::Parser.get_options(opt_file))
  end

  def create(search_name, url)
    Basilisk::Core.create(search_name, url)
  end

end
