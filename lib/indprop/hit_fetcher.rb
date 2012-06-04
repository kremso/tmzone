require 'net_http_downloader'
require 'indprop/list_parser'

module Indprop
  class HitFetcher
    def fetch(url, params, downloader = NetHttpDownloader, parser = Indprop::ListParser.new)
      html = downloader.post(url, params)
      parser.parse(html)
    end
  end
end
