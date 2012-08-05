require 'tort/external_search'
require 'tort/downloader'
require 'tort/parallel_hits_fetcher'
require 'tort/page_search'

module Tort
  class DefaultSearch
    def initialize(engine_name, list_parser, mark_parser, instructions_factory)
      @engine_name = engine_name
      @list_parser = list_parser
      @mark_parser = mark_parser
      @instructions_factory = instructions_factory
    end

    def search(phrase, &block)
      downloader = Downloader.new
      page_search = Tort::PageSearch.new(downloader, @list_parser, @instructions_factory)
      hit_fetcher = Tort::ParallelHitsFetcher.new(downloader, @mark_parser)
      engine = Tort::ExternalSearch.new(@engine_name, page_search, hit_fetcher)
      engine.search(phrase, &block)
    end
  end
end
