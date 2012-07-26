require 'tort/external_search'
require 'tort/downloader'
require 'tort/serial_hits_fetcher'

require 'tort/ctm/page_search'
require 'tort/ctm/list_parser'
require 'tort/ctm/mark_parser'

module Tort
  module CTM
    def self.search(phrase, &block)
      downloader = Downloader.new
      ctm_page_search = CTM::PageSearch.new(downloader, CTM::ListParser.new)
      hit_fetcher = Tort::SerialHitsFetcher.new(downloader, CTM::MarkParser.new)
      ctm = Tort::ExternalSearch.new("CTM", ctm_page_search, hit_fetcher)
      ctm.search(phrase, &block)
    end
  end
end
