require 'uuid'
require 'sse'
require 'channel'
require 'safe_queue'

class MarksController < ApplicationController
  include ActionController::Live

  def research
    @active_tab = :research
  end

  def protect
    @active_tab = :protect
  end

  def search
    @active_tab = :research
    @q = params[:q]
  end

  def search!
    uuid = UUID.new.generate(:compact)
    TORT_QUEUE << { phrase: params[:q], job_id: uuid }

    render status: 202, text: marks_results_path(job: uuid)
  end

  def watch
    @active_tab = :protect
    @q = params[:q]
  end

  def watch!
    render status: 200, nothing: true
  end

  def results
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream)
    queue = SafeQueue.new(Channel.for_job(params[:job]), Tmzone.redis)
    finished = false

    begin
      begin
        queue.next_message do |json_message|
          message = JSON.parse(json_message)
          case message["type"]
          when "results" then
            sse.write(message["data"], event: 'results')
          when "failure" then
            sse.write({}, event: 'failure')
          when "fatal" then
            sse.write({}, event: 'fatal')
            finished = true
          when "status" then
            sse.write(message["data"], event: 'status')
          when "finished" then
            sse.write({}, event: 'finished')
            finished = true
          end
        end
      end while !finished
    rescue IOError

    ensure
      sse.close
    end
  end
end
