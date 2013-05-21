class LazyTortQueue < GirlFriday::WorkQueue
  include Singleton

  def self.define(*options, &block)
    Class.new(LazyTortQueue) do
      define_method(:initialize) do
        super(*options) do |info|
          block.call(info)
        end
      end
    end
  end

  def self.push(*args)
    instance.push(*args)
  end

  def self.status
    instance.status
  end
end
