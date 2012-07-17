module Tort
  class PageSearch
    def initialize(search_results_extraction_strategy)
      @search_results_extraction_strategy = search_results_extraction_strategy
    end

    def search(instructions, downloader)
      html = downloader.download(instructions)
      @search_results_extraction_strategy.process_search_results(html)
    end

    def hits
      @search_results_extraction_strategy.hits
    end

    def has_next_page?
      @search_results_extraction_strategy.has_next_page?
    end

    def next_page_number
      @search_results_extraction_strategy.next_page_number
    end
  end
end
