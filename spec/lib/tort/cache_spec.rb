require 'tort/cache'
require 'tort/tort'

describe Tort::Cache do
  let(:searcher) { mock(:Searcher) }
  let(:backend) { mock(:Backend) }
  let(:block) { lambda{|r|} }

  it 'fetches the search results from the underlying search engine in case of a cache miss' do
    backend.as_null_object
    backend.should_receive(:fetch).with('eset').and_return(nil)
    searcher.should_receive(:search).with('eset', &block)
    cache = Tort::Cache.new('test', searcher, backend)
    cache.search('eset', &block)
  end

  it 'fetches the search results from the cache in case of a cache hit' do
    results_1, results_2 = { name: 'foo' }, { name: 'boo' }
    backend.should_receive(:fetch).with('eset').and_return(YAML::dump([results_1, results_2]))
    block.should_receive(:call).with({ name: 'foo' })
    block.should_receive(:call).with({ name: 'boo' })
    searcher.should_not_receive(:call)
    cache = Tort::Cache.new('test', searcher, backend)
    cache.search('eset', &block)
  end

  it 'caches the search results' do
    results_1, results_2 = stub, stub
    backend.should_receive(:fetch).with('eset').and_return(nil)
    searcher.should_receive(:search).with('eset', &block).and_yield(results_1).and_yield(results_2)
    backend.should_receive(:put).with('eset', YAML::dump([results_1, results_2]))
    cache = Tort::Cache.new('test', searcher, backend)
    cache.search('eset', &block)
  end

  it 'does not cache the search results unless they were retrieved successfully' do
    backend.should_receive(:fetch).with('eset').and_return(nil)
    searcher.should_receive(:search).with('eset', &block).and_raise(Tort::ResourceNotAvailable)
    backend.should_not_receive(:put)
    cache = Tort::Cache.new('test', searcher, backend)
    expect { cache.search('eset', &block) }.to raise_error(Tort::ResourceNotAvailable)
  end
end
