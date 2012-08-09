require 'tort/tort'
require 'channel'

class SearchWorker
  include Sidekiq::Worker

  def perform(phrase, job_id)
    channel = Channel.for_job(job_id)
    Tort.search(phrase) do |on|
      on.results do |hits|
        Tmzone.redis.rpush(channel, { type: "results", data: hits }.to_json)
      end
      on.status_change do |status|
        Tmzone.redis.rpush(channel, { type: "status", data: status }.to_json)
      end
      on.error do
        Tmzone.redis.rpush(channel, { type: 'failure' }.to_json)
      end
    end
    Tmzone.redis.rpush("search:#{job_id}", { type: "finished" }.to_json)
  end
end
