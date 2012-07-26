require 'tort/external_search'
require 'tort/downloader'
require 'tort/serial_hits_fetcher'

require 'tort/indprop/page_search'
require 'tort/indprop/list_parser'
require 'tort/indprop/mark_parser'

module Tort
  module Indprop
    def self.search(phrase, &block)
      downloader = Downloader.new
      indprop_page_search = Indprop::PageSearch.new(downloader, Indprop::ListParser.new)
      hit_fetcher = Tort::SerialHitsFetcher.new(downloader, Indprop::MarkParser.new)
      indprop = Tort::ExternalSearch.new("Indprop", indprop_page_search, hit_fetcher)
      indprop.search(phrase, &block)
    end
  end
end
