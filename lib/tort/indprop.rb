# encoding: utf-8
require 'tort/downloader'
require 'tort/download_instructions'
require 'tort/mark_validity_filter'
require 'tort/indprop/mark_parser'
require 'tort/search_results_extraction_strategy'
require 'tort/page_search'
require 'tort/indprop/list_parser'
require 'tort/serial_hits_fetcher'

module Tort
  module Indprop
    REGISTER_URL = "http://registre.indprop.gov.sk"

    VALID_STATUSES = {
      "v konaní" => true,
      "zverejnená" => true,
      "Platná" => true
    }

    def self.search(phrase, page_number)
      params = {
        "value(majitel)" => "#{phrase}",
        "value(register)" => "oz",
        "value(page)" => page_number
      }
      download_instructions = DownloadInstructions.new(url: "#{REGISTER_URL}/registre/search.do", params: params, method: 'POST')

      hit_fetching_strategy = MarkValidityFilter.new(SerialHitsFetcher.new(Downloader, MarkParser.new), VALID_STATUSES)
      extraction_strategy = SearchResultsExtractionStrategy.new(ListParser.new, hit_fetching_strategy)

      page_search = PageSearch.new(extraction_strategy)
      page_search.search(download_instructions, Downloader)
    end
  end
end
