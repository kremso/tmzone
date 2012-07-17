require 'tort/tort'
require 'tort/page_search'

describe Tort::PageSearch do
  let(:instructions) { stub(:DownloadInstructions) }
  let(:strategy) { strategy = mock(:SearchResultsExtractionStrategy) }
  let(:downloader) { mock(:Downloader) }
  subject { Tort::PageSearch.new(strategy) }

  context 'when the search URL is available' do
    before do
      strategy.should_receive(:process_search_results)
      downloader.should_receive(:download).and_return('html')
    end

    it 'returns list of hits' do
      hits = [stub]
      strategy.stub(hits: hits)
      subject.search(instructions, downloader)
      subject.hits.should == hits
    end

    it 'knows if the search results list has next page' do
      strategy.stub(has_next_page?: true)
      subject.search(instructions, downloader)
      subject.should have_next_page
    end

    it 'knows the next search results page number' do
      strategy.stub(next_page_number: 2)
      subject.search(instructions, downloader)
      subject.next_page_number.should == 2
    end
  end

  context 'when the serach URL is not available' do
    before do
      downloader.should_receive(:download).and_raise(Tort::ResourceNotAvailable)
    end

    it 'raises an exception' do
      expect { subject.search(instructions, downloader) }.to raise_error(Tort::ResourceNotAvailable)
    end
  end
end
