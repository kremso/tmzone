require 'tort/search'
require 'tort/tort'

describe Tort::Search do

  let (:results_callback) { lambda {} }
  let (:error_callback) { lambda {} }
  let (:status_callback) { lambda {|s|} }

  it 'runs a callback each time new search results are available' do
    searcher_1 = stub(:Searcher_1)
    searcher_1.stub(:search).and_yield(stub(total: 10, size: 10).as_null_object)
    searcher_2 = stub(:Searcher_2)
    searcher_2.stub(:search).and_yield(stub(total: 10, size: 10).as_null_object)

    results_callback.should_receive(:call).twice

    search = Tort::Search.new(searcher_1, searcher_2)
    search.search("pepsi") do |on|
      on.results(&results_callback)
      on.status_change(&status_callback)
    end
  end

  it 'runs the callback with the hits from the searcher' do
    hits = [stub]
    searcher = stub(:Searcher)
    searcher.stub(:search).and_yield(stub(size: 10, source: 'indprop', total: 100, hits: hits))

    results_callback.should_receive(:call).with(hits)

    search = Tort::Search.new(searcher)
    search.search("pepsi") do |on|
      on.results(&results_callback)
      on.status_change(&status_callback)
    end
  end

  let(:results_callback) { (lambda{|h|}).as_null_object }

  context 'runs the callback with the status information, which' do
    let(:indprop_searcher) { stub(:IndpropSearcher) }
    let(:wipo_searcher) { stub(:WipoSearcher) }

    before do
      indprop_searcher.stub(:search).and_yield(stub(total: 100, size: 10).as_null_object)
      wipo_searcher.stub(:search).and_yield(stub(total: 100, size: 10).as_null_object)
    end

    it 'contains information about total hits fetched so far' do
      status_callback.should_receive(:call) do |status|
        status.fetched.should == 10
      end.ordered

      status_callback.should_receive(:call) do |status|
        status.fetched.should == 20
      end.ordered

      search = Tort::Search.new(indprop_searcher, wipo_searcher)
      search.search("pepsi") do |on|
        on.results(&results_callback)
        on.status_change(&status_callback)
      end
    end

    it 'contains information about total number of hits expected' do
      status_callback.should_receive(:call) do |status|
        status.total.should == 100
      end.ordered

      status_callback.should_receive(:call) do |status|
        status.total.should == 200
      end.ordered

      search = Tort::Search.new(indprop_searcher, wipo_searcher)
      search.search("pepsi") do |on|
        on.results(&results_callback)
        on.status_change(&status_callback)
      end
    end

    it 'knows when the total number of hits is final' do
      search = Tort::Search.new(indprop_searcher, wipo_searcher)

      indprop_searcher.stub(:search).and_yield(stub(total: 10, size: 10).as_null_object)
      wipo_searcher.stub(:search).and_yield(stub(total: 10, size: 10).as_null_object)

      status_callback.should_receive(:call) do |status|
        status.should_not have_finalized_total
      end.ordered

      status_callback.should_receive(:call) do |status|
        status.should have_finalized_total
      end.ordered

      search.search("pepsi") do |on|
        on.results(&results_callback)
        on.status_change(&status_callback)
      end
    end
  end

  it 'does not recalculate the total number of expected hits if the information comes from the same source' do
    searcher = stub(:Searcher)
    searcher.stub(:search).and_yield(stub(total: 10, size: 10, source: 'WIPO').as_null_object)
                          .and_yield(stub(total: 10, size: 10, source: 'WIPO').as_null_object)
    status_callback.should_receive(:call) do |status|
      status.total.should == 10
    end.ordered

    status_callback.should_receive(:call) do |status|
      status.total.should == 10
    end.ordered

    search = Tort::Search.new(searcher)
    search.search("pepsi") do |on|
      on.results(&results_callback)
      on.status_change(&status_callback)
    end
  end

  context 'when one of the searchers fails' do
    it 'calls the error callback' do
      searcher = stub(:Searcher)
      search = Tort::Search.new(searcher)

      searcher.stub(:search).and_raise(Tort::ResourceNotAvailable)

      error_callback.should_receive(:call)
      results_callback.should_not_receive(:call)

      search.search("pepsi") do |on|
        on.results(&results_callback)
        on.error(&error_callback)
        on.status_change(&status_callback)
      end
    end

    it 'considers all hits from that source loaded' do
      searcher_1 = stub(:Searcher)
      searcher_2 = stub(:Searcher)
      search = Tort::Search.new(searcher_1, searcher_2)

      searcher_1.stub(:search).and_raise(Tort::ResourceNotAvailable)
      searcher_2.stub(:search).and_yield(stub(total: 10, size: 10).as_null_object)

      status_callback.should_receive(:call) do |status|
        status.should_not have_finalized_total
      end.ordered

      status_callback.should_receive(:call) do |status|
        status.should have_finalized_total
      end.ordered

      search.search("pepsi") do |on|
        on.results(&results_callback)
        on.status_change(&status_callback)
      end
    end
  end
end
