module Tort
  class Search
    class Status
      attr_reader :fetched, :total

      def initialize(total_searchers)
        @fetched = 0
        @total = 0
        @total_searchers = total_searchers
        @totals = {}
      end

      def update(source, fetched, total)
        unless @totals[source]
          @total += total
          @totals[source] = total
        end
        @fetched += fetched
      end

      def has_finalized_total?
        @total_searchers == @totals.size
      end

      def as_json(options = {})
        { fetched: fetched, total: total, has_finalized_total?: has_finalized_total? }
      end
    end

    def initialize(*searchers)
      @searchers = searchers
    end

    def search(phrase, &block)
      block.call(self)

      status = Status.new(@searchers.size)
      @searchers.each do |searcher|
        begin
          searcher.search(phrase) do |search_results|
            status.update(searcher, search_results.size, search_results.total)
            @results_callback.call(search_results.hits)
            @status_change_callback.call(status)
          end
        rescue Tort::ResourceNotAvailable
          status.update(searcher, 0, 0)
          @status_change_callback.call(status)
          @error_callback.call if @error_callback
        end
      end
    end

    def results(&block)
      @results_callback = block
    end

    def error(&block)
      @error_callback = block
    end

    def status_change(&block)
      @status_change_callback = block
    end
  end
end
