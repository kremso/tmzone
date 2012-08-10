require 'tort/tort'
require 'channel'
require 'safe_queue'

class SearchWorker
  def self.perform(phrase, job_id)
    channel = Channel.for_job(job_id)
    queue = SafeQueue.new(channel, Tmzone.redis)

    Tort.search(phrase) do |on|
      on.results do |hits|
        queue.push({ type: "results", data: hits }.to_json)
      end
      on.status_change do |status|
        queue.push({ type: "status", data: status }.to_json)
      end
      on.error do
        queue.push({ type: 'failure' }.to_json)
      end
    end
    queue.push({ type: "finished" }.to_json)
  end

  def handle(ex)
    if ex.respond_to? :job_id
      channel = Channel.for_job(ex.job_id)
      queue = SafeQueue.new(channel, Tmzone.redis)
      queue.push({ type: 'fatal' }.to_json)
    end
  end
end
