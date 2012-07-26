require 'tort/search'

describe Tort::Search do

  let (:block) { lambda {} }

  it 'runs a callback each time new search results are available' do
    searcher_1 = stub(:Searcher_1)
    searcher_1.stub(:search).and_yield(stub(total: 10, size: 10).as_null_object)
    searcher_2 = stub(:Searcher_2)
    searcher_2.stub(:search).and_yield(stub(total: 10, size: 10).as_null_object)

    block.should_receive(:call).twice

    search = Tort::Search.new(searcher_1, searcher_2)
    search.search("pepsi", &block)
  end

  it 'runs the callback with the hits from the searcher' do
    hits = [stub]
    searcher = stub(:Searcher)
    searcher.stub(:search).and_yield(stub(size: 10, source: 'indprop', total: 100, hits: hits))

    block.should_receive(:call).with(anything, hits)

    search = Tort::Search.new(searcher)
    search.search("pepsi", &block)
  end

  context 'runs the callback with the status information, which' do
    let(:indprop_searcher) { stub(:IndpropSearcher) }
    let(:wipo_searcher) { stub(:WipoSearcher) }

    before do
      indprop_searcher.stub(:search).and_yield(stub(total: 100, size: 10).as_null_object)
      wipo_searcher.stub(:search).and_yield(stub(total: 100, size: 10).as_null_object)
    end

    it 'contains information about total hits fetched so far' do
      block.should_receive(:call) do |status, search_results|
        status.fetched.should == 10
      end.ordered

      block.should_receive(:call) do |status, search_results|
        status.fetched.should == 20
      end.ordered

      search = Tort::Search.new(indprop_searcher, wipo_searcher)
      search.search("pepsi", &block)
    end

    it 'contains information about total number of hits expected' do
      block.should_receive(:call) do |status, search_results|
        status.total.should == 100
      end.ordered

      block.should_receive(:call) do |status, search_results|
        status.total.should == 200
      end.ordered

      search = Tort::Search.new(indprop_searcher, wipo_searcher)
      search.search("pepsi", &block)
    end
  end

  it 'does not recalculate the total number of expected hits if the information comes from the same source' do
    searcher = stub(:Searcher)
    searcher.stub(:search).and_yield(stub(total: 10, size: 10, source: 'WIPO').as_null_object)
                          .and_yield(stub(total: 10, size: 10, source: 'WIPO').as_null_object)
    block.should_receive(:call) do |status, search_results|
      status.total.should == 10
    end.ordered

    block.should_receive(:call) do |status, search_results|
      status.total.should == 10
    end.ordered

    search = Tort::Search.new(searcher)
    search.search("pepsi", &block)
  end
end
