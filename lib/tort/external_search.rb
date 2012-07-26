module Tort
  class ExternalSearch
    class SearchResults < Struct.new(:hits, :total, :source)
      def size
        hits.size
      end
    end

    def initialize(name, page_search, results_fetcher)
      @name = name
      @page_search = page_search
      @results_fetcher = results_fetcher
    end

    def search(phrase, &block)
      @page_search.search(phrase)

      @page_search.each_search_results_page do |hits_download_instructions|
        results = @results_fetcher.fetch_hits(hits_download_instructions)
        block.call(SearchResults.new(results, @page_search.total_hits, @name))
      end
    end
  end
end
