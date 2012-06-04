require 'net_http_downloader'
require 'indprop/mark_parser'

module Indprop
  class MarkFetcher
    def fetch_mark(hit, downloader = NetHttpDownloader, parser = Indprop::MarkParser.new)
      html = downloader.get(hit.detail_url)
      parser.parse(html, hit)
    end
  end
end
