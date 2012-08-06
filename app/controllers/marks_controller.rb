require 'uuid'
require 'sse'

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
      loop do
        redis.subscribe("search:#{params[:job]}") do |on|
          on.message do |channel, message|
            sse.write(message, event: 'results')
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
