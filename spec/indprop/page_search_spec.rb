require 'indprop/page_search'

describe Indprop::PageSearch do
  it 'fetches the marks using the given strategy' do
    hits = stub
    marks = stub
    params = {
      "value(majitel)" => "*term*",
      "value(register)" => "oz",
      "value(page)" => 2
    }
    hit_fetcher = mock(:HitFetcher)
    mark_fetcher = mock(:MarkFetcher)
    hit_fetcher.should_receive(:fetch).with("http://registre.indprop.gov.sk/registre/search.do", params).and_return([hits, 3])
    mark_fetcher.should_receive(:fetch).with(hits).and_return(marks)

    results = subject.search('term', 2, hit_fetcher, mark_fetcher)
    results.marks.should == marks
    results.next_page_number.should == 3
  end
end
