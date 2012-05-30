require 'net_http_downloader'
require 'indprop_mark_parser'

class IndpropMarkFetcher
  def self.fetch_mark(hit, downloader = NetHttpDownloader, parser = IndpropMarkParser)
    html = downloader.get(hit.detail_url)
    parser.parse(html, hit)
  end
end
