module Tort
  class SearchResultsExtractionStrategy
    def initialize(list_parser, hit_fetching_strategy)
      @list_parser = list_parser
      @hit_fetching_strategy = hit_fetching_strategy
    end

    def process_search_results(html)
      download_instructions = @list_parser.parse_download_instructions(html)
      @hit_fetching_strategy.fetch_hits(download_instructions)
    end

    def hits
      @hit_fetching_strategy.hits
    end

    def has_next_page?
      @list_parser.has_next_page?
    end
  end
end
