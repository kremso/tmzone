require 'tort/external_search'
require 'tort/downloader'
require 'tort/serial_hits_fetcher'

require 'tort/wipo/page_search'
require 'tort/wipo/list_parser'
require 'tort/wipo/mark_parser'

module Tort
  module Wipo
    def self.search(phrase, &block)
      downloader = Downloader.new
      wipo_page_search = Wipo::PageSearch.new(downloader, Wipo::ListParser.new)
      hit_fetcher = Tort::SerialHitsFetcher.new(downloader, Wipo::MarkParser.new)
      wipo = Tort::ExternalSearch.new("WIPO", wipo_page_search, hit_fetcher)
      wipo.search(phrase, &block)
    end
  end
end
