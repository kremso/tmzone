require 'uuid'
require 'sse'
require 'channel'

class MarksController < ApplicationController
  include ActionController::Live

  def search

  end

  def search!
    uuid = UUID.new.generate(:compact)
    SearchWorker.perform_async(params[:q], uuid)

    render status: 202, text: marks_results_path(job: uuid)
  end

  def results
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream)
    redis = Redis.new

    begin
      channel = Channel.for_job(params[:job])
      redis.subscribe(channel) do |on|
        on.message do |channel, json_message|
          message = JSON.parse(json_message)
          case message["type"]
          when "results" then
            sse.write(message.except("type"), event: 'results')
          when "error" then
            sse.write({}, event: 'error')
          when "finished" then
            sse.write({}, event: 'finished')
            redis.unsubscribe(channel)
          end
        end
      end
    rescue IOError
      # When the client disconnects, we'll get an IOError on write
    ensure
      sse.close
    end

  end
end
