# encoding: utf-8

module Tort
  module Indprop
    class MarkValidityFilter
      def initialize(decorated_fetcher)
        @decorated_fetcher = decorated_fetcher
      end

      VALID_STATUSES = {
          "v konaní" => true,
          "zverejnená" => true,
          "Platná" => true
      }

      def fetch_hits(*args)
        @decorated_fetcher.fetch_hits(*args).select do |mark|
          VALID_STATUSES[mark.status]
        end
      end
    end
  end
end
