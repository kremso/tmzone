require 'indprop_list_parser'
require 'indprop_mark_fetcher'
require 'net_http_downloader'

class IndpropSearch
  class SearchResultsPage < Struct.new(:hits, :next_page_number)
  end

  def self.search(term, page_number, downloader = NetHttpDownloader, list_parser = IndpropListParser.new, mark_fetcher = IndpropMarkFetcher)
    params = {
      "value(majitel)" => "*#{term}*",
      "value(register)" => "oz",
      "value(page)" => page_number
    }
    html = downloader.post("http://registre.indprop.gov.sk/registre/search.do", params)
    marks = list_parser.parse(html).collect do |hit|
      mark_fetcher.fetch_mark(hit)
    end
    SearchResultsPage.new(marks, list_parser.next_page_number)
  end
end
