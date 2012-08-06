require 'uri'
require 'net/http'

require 'tort/tort'

module Tort
  class Downloader
    def download(instructions)
      uri = URI.parse(instructions.url)
      http = Net::HTTP.new(uri.host, uri.port)

      case instructions.method
      when 'GET'  then request = Net::HTTP::Get.new(uri.request_uri)
      when 'POST' then request = Net::HTTP::Post.new(uri.request_uri)
      else raise "Unsupported method: #{instructions.method}"
      end

      request['User-Agent'] = 'Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20100101 Firefox/14.0.1'

      if instructions.cookies
        request['Cookie'] = instructions.cookies
      end

      if instructions.params
        if instructions.method == 'POST'
          request.set_form_data(instructions.params)
        else
          raise "Parameter setting only supported for POST requests"
        end
      end

      begin
        @response = http.request(request)
      rescue Timeout::Error
        raise ResourceNotAvailable
      end

      if @response.code == "200"
        @response.body
      else
        raise ResourceNotAvailable
      end
    end

    def response_cookies
      @response.response['set-cookie']
    end
  end
end
