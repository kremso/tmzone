require 'tort/download_instructions'

module Tort
  class PageSearch
    def initialize(downloader, list_parser, instructions_factory)
      @downloader = downloader
      @list_parser = list_parser
      @instructions_factory = instructions_factory
    end

    def search(phrase)
      @phrase = phrase
      @next_page_instructions = @instructions_factory.initial_search_instructions(@phrase)
    end

    def each_search_results_page(&block)
      page_number = 1
      while @next_page_instructions
        html = @downloader.download(@next_page_instructions)
        @list_parser.parse(html)
        instructions =
          @list_parser.hits_download_instructions(@instructions_factory.hits_download_instructions_factory(@phrase, @downloader.response_cookies))
        block.call(instructions)
        page_number += 1
        @next_page_instructions =
          @list_parser.next_page_download_instructions(@instructions_factory.page_download_instructions(@phrase, page_number, @downloader.response_cookies))
      end
    end

    def total_hits
      @list_parser.total_hits
    end
  end
end
