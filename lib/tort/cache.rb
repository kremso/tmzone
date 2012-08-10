require 'tort/cache/redis_backend'
require 'yaml'

module Tort
  class Cache
    def initialize(namespace, searcher, backend = Tort::RedisBackend.new(namespace))
      @searcher = searcher
      @backend = backend
    end

    def search(phrase, &block)
      if (batched_results = @backend.fetch(phrase))
        YAML::load(batched_results).each do |results|
          block.call(results)
        end
      else
        batched_results = []
        @searcher.search(phrase) do |results|
          batched_results << results
          block.call(results)
        end
        @backend.put(phrase, YAML::dump(batched_results))
      end
    end
  end
end
