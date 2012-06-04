require 'indprop/indprop'

module Indprop
  class PageSearch

    class SearchResultsPage < Struct.new(:marks, :next_page_number)
    end

    def search(term, page_number, hit_fetcher, marks_fetcher)
      params = {
        "value(majitel)" => "#{term}",
        "value(register)" => "oz",
        "value(page)" => page_number
      }
      hits, next_page_number = hit_fetcher.fetch("#{Indprop::REGISTER_URL}/registre/search.do", params)
      marks = marks_fetcher.fetch(hits)
      SearchResultsPage.new(marks, next_page_number)
    end
  end
end
