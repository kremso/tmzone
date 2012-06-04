require 'indprop/mark_fetcher'

describe Indprop::MarkFetcher do
  let(:downloader) { double(:Downloader) }
  let(:parser)     { double(:MarkParser) }

  it 'downloads the mark detail html' do
    hit = stub(detail_url: 'http://detail')
    downloader.should_receive(:get).with('http://detail')
    subject.fetch_mark(hit, downloader, parser.as_null_object)
  end

  it 'parses details of the mark and completes the hit data' do
    hit = stub.as_null_object
    downloader.stub(get: 'html')
    parser.should_receive(:parse).with('html', hit)
    subject.fetch_mark(hit, downloader, parser)
  end
end
