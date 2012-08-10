module Tort
  class RedisBackend
    def initialize(namespace, redis = Tmzone.redis, timeout = 1.day)
      @redis = redis
      @namespace = "tort:cache:#{namespace}"
      @timeout = timeout
    end

    def fetch(key)
      @redis.get(cache_key(key))
    end

    def put(key, contents)
      @redis.setex(cache_key(key), @timeout, contents)
    end

    private

    def cache_key(key)
      "#{@namespace}:#{key}"
    end
  end
end
