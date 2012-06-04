require 'indprop/mark_fetcher'

module Indprop
  class SerialMarksFetcher
    def fetch(hits, mark_fetcher = Indprop::MarkFetcher.new)
      hits.collect do |hit|
        mark_fetcher.fetch_mark(hit)
      end
    end
  end
end
