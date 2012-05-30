require 'net/http'
require 'uri'

class NetHttpDownloader
  def self.get(url)
    uri = URI.parse(url)
    Net::HTTP.get_response(uri).body
  end

  def self.post(url, params)
    uri = URI.parse(url)
    Net::HTTP.post_form(uri, params).body
  end
end
