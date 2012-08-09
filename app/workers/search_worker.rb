require 'tort/tort'
require 'channel'

class SearchWorker
  include Sidekiq::Worker

  def perform(phrase, job_id)
    redis = Redis.new
    channel = Channel.for_job(job_id)
    Tort.search(phrase) do |on|
      on.results do |hits|
        redis.publish(channel, { type: "results", data: hits }.to_json)
      end
      on.status_change do |status|
        redis.publish(channel, { type: "status", data: status }.to_json)
      end
      on.error do
        redis.publish(channel, { type: 'failure' }.to_json)
      end
    end
    redis.publish("search:#{job_id}", { type: "finished" }.to_json)
  end
end
