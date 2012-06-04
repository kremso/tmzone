require 'indprop/page_search'
require 'indprop/hit_fetcher'
require 'indprop/serial_marks_fetcher'
require 'indprop/mark_validity_filter'

module Indprop
  REGISTER_URL = "http://registre.indprop.gov.sk"

  def self.search(term)
    page_searcher = PageSearch.new
    page_searcher.search(term, 1, MarkValidityFilter.new(HitFetcher.new), SerialMarksFetcher.new).marks
  end
end
