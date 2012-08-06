require 'tort/wipo/list_parser'

describe Tort::Wipo::ListParser do
  let(:instructions_factory) { mock(:InstructionsFactory) }

  it 'parses download instructions for each search results hit' do
    subject.parse(File.read('spec/fixtures/wipo/nivea.html'))

    instructions_factory.should_receive(:new).with(url: '/romarin//detail.do?ID=235')
    instructions_factory.should_receive(:new).exactly(24).times

    subject.hits_download_instructions(instructions_factory)
  end

  it 'returns the parsed instructions' do
    instructions_factory.as_null_object
    subject.parse(File.read('spec/fixtures/wipo/nivea.html'))
    subject.hits_download_instructions(instructions_factory).should have(25).instructions
  end

  it 'parses download instructions for the next search results page' do
    subject.parse(File.read('spec/fixtures/wipo/nivea.html'))

    instructions_factory.should_receive(:new).with(url: '/romarin//searchHit.do?pager.offset=25')

    subject.next_page_download_instructions(instructions_factory)
  end

  it 'returns nil instead of download instructions when there is no next page' do
    subject.parse(File.read('spec/fixtures/wipo/nivea_no_next_link.html'))
    subject.next_page_download_instructions(instructions_factory).should be_nil
  end

  it 'returns nil instead of download instructions when the pagination is on the last page' do
    subject.parse(File.read('spec/fixtures/wipo/last_page.html'))
    subject.next_page_download_instructions(instructions_factory).should be_nil
  end

  it 'knows the total number of hits' do
    subject.parse(File.read('spec/fixtures/wipo/nivea.html'))
    subject.total_hits.should == 236
  end

  context 'when parsing page informing about no search results found' do
    it 'parses no hits download instructions' do
      subject.parse(File.read('spec/fixtures/wipo/unsuccessful_search.html'))
      factory = mock(:Factory)
      subject.hits_download_instructions(factory).should be_empty
    end

    it 'knows there is not next page' do
      subject.parse(File.read('spec/fixtures/wipo/unsuccessful_search.html'))
      factory = mock(:Factory)
      subject.next_page_download_instructions(factory).should be_nil
    end

    it 'returns 0 as the total number of hits' do
      subject.parse(File.read('spec/fixtures/wipo/unsuccessful_search.html'))
      subject.total_hits.should == 0
    end
  end

  context 'when parsing search results with only sinlge page' do
    it 'knows the total number of hits is equal to number of search results on that page' do
      subject.parse(File.read('spec/fixtures/wipo/few_search_results.html'))
      subject.total_hits.should == 5
    end
  end
end
