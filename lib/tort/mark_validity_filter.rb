module Tort
  class MarkValidityFilter
    def initialize(decorated_fetcher, valid_statuses)
      @decorated_fetcher = decorated_fetcher
      @valid_statuses = valid_statuses
    end

    def fetch_hits(*args)
      @decorated_fetcher.fetch_hits(*args).select do |mark|
        @valid_statuses[mark.status]
      end
    end
  end
end
