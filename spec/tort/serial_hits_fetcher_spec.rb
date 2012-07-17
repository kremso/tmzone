require 'tort/tort'
require 'tort/serial_hits_fetcher'

describe Tort::SerialHitsFetcher do
  let(:downloader) { mock(:Downloader) }
  let(:mark_parser) { mock(:MarkParser) }

  subject { Tort::SerialHitsFetcher.new(downloader, mark_parser) }

  it 'fetches details for each hit using the download instructions' do
    html = 'html'
    mark_download_instructions = stub
    hit = stub
    factory = stub.as_null_object

    downloader.should_receive(:download).with(mark_download_instructions) { html }
    mark_parser.should_receive(:parse).with(html, factory) { hit }

    subject.fetch_hits([mark_download_instructions], factory)
  end

  context 'when the hit cannot be retrieved' do
    it 'marks the hit as unavailable and retains its original name' do
      name = 'name'
      mark_download_instructions = stub(name: name)
      hit = stub
      factory = stub

      downloader.should_receive(:download).with(mark_download_instructions).and_raise(Tort::ResourceNotAvailable)
      factory.should_receive(:new).with(incomplete: true, name: name)
      subject.fetch_hits([mark_download_instructions], factory)
    end
  end
end
