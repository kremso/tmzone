require 'indprop/hit_fetcher'

describe Indprop::HitFetcher do
  it 'requests the HTML with the give parameters' do
    url = "http://indprop"
    params = {}
    downloader = mock(:Downloader)
    parser = mock(:Parser)
    hits = stub

    downloader.should_receive(:post).with(url, params).and_return('html')
    parser.should_receive(:parse).with('html').and_return(hits)
    subject.fetch(url, params, downloader, parser).should == hits
  end
end
