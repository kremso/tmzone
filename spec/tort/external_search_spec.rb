require 'tort/external_search'

describe Tort::ExternalSearch do
  let(:page_search) { stub(:PageSearch) }
  let(:results_fetcher) { stub(:ResultsFetcher) }

  let(:block) { lambda{} }

  it 'searches for the given phrase and yields search results information into the passed block' do
    download_instructions = [stub]
    results = [stub]

    page_search.should_receive(:search).with('pepsi')
    page_search.stub(:each_search_results_page).and_yield(download_instructions)
    page_search.stub(total_hits: 1)

    results_fetcher.should_receive(:fetch_hits).with(download_instructions).and_return(results)

    block.should_receive(:call) do |search_results|
      search_results.hits.should == results
    end
    searcher = Tort::ExternalSearch.new("WIPO", page_search, results_fetcher)
    searcher.search('pepsi', &block)
  end

  context 'when search results were found' do
    before do
      page_search.as_null_object
      page_search.stub(:each_search_results_page).and_yield([])
      results_fetcher.stub(fetch_hits: [])
    end

    it 'yields information about total number of hits from the given search engine' do
      page_search.stub(total_hits: 10)

      block.should_receive(:call) do |search_results|
        search_results.total.should == 10
      end
      searcher = Tort::ExternalSearch.new("WIPO", page_search, results_fetcher)
      searcher.search('pepsi', &block)
    end

    it 'yields information about the source of search results' do
      block.should_receive(:call) do |search_results|
        search_results.source.should == "WIPO"
      end
      searcher = Tort::ExternalSearch.new("WIPO", page_search, results_fetcher)
      searcher.search('pepsi', &block)
    end

    it 'yields information about the number of fetched search results' do
      results_fetcher.stub(fetch_hits: [stub, stub])
      block.should_receive(:call) do |search_results|
        search_results.size.should == 2
      end
      searcher = Tort::ExternalSearch.new("WIPO", page_search, results_fetcher)
      searcher.search('pepsi', &block)
    end
  end

  context 'when no search results were found' do
    it 'does not call the block' do
      page_search.stub(search: nil, each_search_results_page: nil)
      block.should_not_receive(:call)
      searcher = Tort::ExternalSearch.new("WIPO", page_search, results_fetcher)
      searcher.search('pepsi', &block)
    end
  end
end
