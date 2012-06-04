require 'indprop/serial_marks_fetcher'

describe Indprop::SerialMarksFetcher do
  it 'fetches all hits in series' do
    hit = stub
    mark_fetcher = stub(:MarkFetcher)
    mark_fetcher.should_receive(:fetch_mark).with(hit)
    subject.fetch([hit], mark_fetcher)
  end
end
