# encoding: utf-8
require 'tort/indprop/mark_validity_filter'

describe Tort::Indprop::MarkValidityFilter do
  let(:decorated_fetcher) { mock(:DecoratedFetcher) }
  subject { Tort::Indprop::MarkValidityFilter.new(decorated_fetcher) }

  it 'forwards all parameters to the decorated fetcher' do
    instructions = stub
    factory = stub
    decorated_fetcher.should_receive(:fetch_hits).with(instructions, factory) { [] }
    subject.fetch_hits(instructions, factory)
  end

  it 'allows marks that have status "v konaní"' do
    mark = stub(status: "v konaní")
    decorated_fetcher.stub(fetch_hits: [mark])
    subject.fetch_hits.should == [mark]
  end

  it 'allows marks that have status "zverejnená"' do
    mark = stub(status: "zverejnená")
    decorated_fetcher.stub(fetch_hits: [mark])
    subject.fetch_hits.should == [mark]
  end

  it 'allows marks that have status "Platná"' do
    mark = stub(status: "Platná")
    decorated_fetcher.stub(fetch_hits: [mark])
    subject.fetch_hits.should == [mark]
  end

  it 'rejects marks with different statuses' do
    mark = stub(status: "zamietnutá")
    decorated_fetcher.stub(fetch_hits: [mark])
    subject.fetch_hits.should == []
  end
end
