require 'indprop/indprop_search'
require 'ostruct'

describe IndpropSearch do
  let(:downloader)   { double(:Downloader) }
  let(:list_parser)  { double(:ListParser) }
  let(:mark_fetcher) { double(:MarkFetcher) }

  it 'searches indprop for the given term and and page' do
    params = {
      "value(majitel)" => "*term*",
      "value(register)" => "oz",
      "value(page)" => 3
    }
    downloader.should_receive(:post).with("http://registre.indprop.gov.sk/registre/search.do", params)
    IndpropSearch.search("term", 3, downloader, list_parser.as_null_object, mark_fetcher.as_null_object)
  end

  it 'parses the search results HTML and fills in search results' do
    hit = stub(:Hit)
    mark = stub(:Mark)

    list_parser = stub(:ListParser, parse: [hit], next_page_number: 3)

    mark_fetcher.should_receive(:fetch_mark).with(hit).and_return(mark)

    results = IndpropSearch.search("term", 1, downloader.as_null_object, list_parser, mark_fetcher)
    results.hits.should == [mark]
    results.next_page_number.should == 3
  end
end
