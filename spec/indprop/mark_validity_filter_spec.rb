# encoding: utf-8
require 'indprop/mark_validity_filter'

describe Indprop::MarkValidityFilter do
  let(:decorated_fetcher) { mock(:DecoratedFetcher) }
  subject { Indprop::MarkValidityFilter.new(decorated_fetcher) }

  it 'forwards all parameters to the decorated fetcher' do
    decorated_fetcher.should_receive(:fetch).with('foo', 'boo').and_return([[], 1])
    subject.fetch('foo', 'boo')
  end

  it 'allows marks that have status "v konaní"' do
    mark = stub(status: "v konaní")
    decorated_fetcher.stub(fetch: [[mark], 1])
    subject.fetch.should == [[mark], 1]
  end

  it 'allows marks that have status "zverejnená"' do
    mark = stub(status: "zverejnená")
    decorated_fetcher.stub(fetch: [[mark], 1])
    subject.fetch.should == [[mark], 1]
  end

  it 'allows marks that have status "Platná"' do
    mark = stub(status: "Platná")
    decorated_fetcher.stub(fetch: [[mark], 1])
    subject.fetch.should == [[mark], 1]
  end

  it 'rejects marks with different statuses' do
    mark = stub(status: "zamietnutá")
    decorated_fetcher.stub(fetch: [[mark], 1])
    subject.fetch.should == [[], 1]
  end
end
