require 'uri'
require 'net/http'

require 'tort/tort'

module Tort
  class Downloader
    def self.download(instructions)
      uri = URI.parse(instructions.url)
      http = Net::HTTP.new(uri.host, uri.port)

      case instructions.method
      when 'GET'  then request = Net::HTTP::Get.new(uri.request_uri)
      when 'POST' then request = Net::HTTP::Post.new(uri.request_uri)
      else raise "Unsupported method: #{instructions.method}"
      end

      if instructions.cookies
        request['Cookie'] = instructions.cookies
      end

      if instructions.params
        if instructions.method == 'POST'
          request.set_form_data(instructions.params)
        else
          raise "Parameter setting only supported for GET requests"
        end
      end

      response = http.request(request)
      if response.code == "200"
        response.body
      else
        debugger
        raise ResourceNotAvailable
      end
    end
  end
end
