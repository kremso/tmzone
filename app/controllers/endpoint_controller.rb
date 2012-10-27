class EndpointController < ApplicationController
  def log
    puts "BODY: #{request.raw_post}"
    render nothing: true
  end
end
