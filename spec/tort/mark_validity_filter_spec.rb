# encoding: utf-8
require 'tort/mark_validity_filter'

describe Tort::MarkValidityFilter do
  let(:decorated_fetcher) { mock(:DecoratedFetcher) }

  it 'forwards all parameters to the decorated fetcher' do
    filter = Tort::MarkValidityFilter.new(decorated_fetcher, {})
    instructions = stub
    factory = stub
    decorated_fetcher.should_receive(:fetch_hits).with(instructions, factory) { [] }
    filter.fetch_hits(instructions, factory)
  end

  it 'allows specified marks' do
    filter = Tort::MarkValidityFilter.new(decorated_fetcher, {"v konaní" => true})
    mark = stub(status: "v konaní")
    decorated_fetcher.stub(fetch_hits: [mark])
    filter.fetch_hits.should == [mark]
  end

  it 'rejects marks that were not specified' do
    filter = Tort::MarkValidityFilter.new(decorated_fetcher, {"v konaní" => true})
    mark = stub(status: "zamietnutá")
    decorated_fetcher.stub(fetch_hits: [mark])
    filter.fetch_hits.should == []
  end
end
