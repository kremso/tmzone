require 'tort/tort'

class SearchWorker
  include Sidekiq::Worker

  def perform(phrase, job_id)
    redis = Redis.new
    Tort.search(phrase) do |on|
      channel = "search:#{job_id}"
      on.results do |status, hits|
        redis.publish(channel, { type: "results", status: status, hits: hits }.to_json)
      end
      on.error do
        redis.publish(channel, { type: 'error' }.to_json)
      end
    end
    redis.publish("search:#{job_id}", { type: "finished" }.to_json)
  end
end
