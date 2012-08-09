require 'safe_queue'

describe SafeQueue do
  let(:redis) { mock(:redis).as_null_object }
  let(:channel) { 'channel' }
  let(:queue) { SafeQueue.new('channel', redis) }
  let(:block) { lambda{} }
  let(:message) { stub }

  it 'retrieves messages from the redis list and calls the block' do
    redis.should_receive(:blpop).and_return([channel, message])

    block.should_receive(:call).with(message).ordered
    queue.next_message(&block)
  end

  it 'does not loose the message if the block terminates unexpectedly' do
    redis.should_receive(:blpop).and_return([channel, message])
    redis.should_receive(:lpush).with(channel, message)

    block.should_receive(:call).and_raise(IOError)
    begin
      queue.next_message(&block)
    rescue
    end
  end

  it 'reraises the exception raised from the block' do
    redis.should_receive(:blpop).and_return([channel, message])

    block.should_receive(:call).and_raise(IOError)
    expect { queue.next_message(&block) }.to raise_error(IOError)
  end
end
