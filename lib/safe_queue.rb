class SafeQueue
  def initialize(channel, redis)
    @channel = channel
    @redis = redis
  end

  def next_message(&block)
    begin
      _, message = @redis.blpop(@channel)
      block.call(message)
    rescue => error
      @redis.lpush(@channel, message)
      raise error
    end
  end

  def push(message)
    @redis.rpush(@channel, message)
  end
end
