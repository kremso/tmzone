require 'tort/tort'

class SearchWorker
  include Sidekiq::Worker

  def perform(phrase, job_id)
    redis = Redis.new
    Tort.search(phrase) do |status, hits|
      redis.publish("search:#{job_id}", { type: "results", status: status, hits: hits }.to_json)
    end
    redis.publish("search:#{job_id}", { type: "finished" }.to_json)
  end
end
