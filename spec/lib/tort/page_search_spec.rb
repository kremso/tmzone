require 'tort/page_search'

describe Tort::PageSearch do
  let(:downloader) { mock(:Downloader) }
  let(:list_parser) { mock(:ListParser) }
  let(:instructions_factory) { mock(:InstructionsFactory) }

  subject { Tort::PageSearch.new(downloader, list_parser, instructions_factory) }

  it 'asks for the initial search instructions' do
    instructions_factory.should_receive(:initial_search_instructions).with('pepsi')
    subject.search('pepsi')
  end

  it 'knows the total number of hits for that search' do
    list_parser.stub(total_hits: 45)
    subject.total_hits.should == 45
  end

  let(:block) { lambda { |a| } }

  it 'yields download instructions for each set of hits for each search results page' do
    instructions_factory.as_null_object
    downloader.as_null_object
    initial_instructions = stub
    hits_instructions = stub

    instructions_factory.stub(initial_search_instructions: initial_instructions)
    downloader.should_receive(:download).with(initial_instructions).and_return('html')
    list_parser.should_receive(:parse).with('html')
    list_parser.should_receive(:hits_download_instructions).and_return(hits_instructions)

    block.should_receive(:call).with(hits_instructions)

    list_parser.should_receive(:next_page_download_instructions)

    subject.search('pepsi')
    subject.each_search_results_page(&block)
  end

  it 'asks the instructions factory for initial search instructions' do
    instructions_factory.should_receive(:initial_search_instructions).with('pepsi')
    subject.search('pepsi')
  end

  it 'asks the instructions factory for hits download instructions' do
    instructions_factory.as_null_object
    downloader.as_null_object
    list_parser.as_null_object.stub(next_page_download_instructions: nil)

    downloader.stub(response_cookies: 'cookies')
    instructions_factory.should_receive(:hits_download_instructions_factory).with('pepsi', 'cookies').and_return(stub)
    subject.search('pepsi')
    subject.each_search_results_page(&block)
  end

  it 'asks the instructions factory for next page download instructions' do
    instructions_factory.as_null_object
    downloader.as_null_object
    list_parser.as_null_object.stub(next_page_download_instructions: nil)

    downloader.stub(response_cookies: 'cookies')
    instructions_factory.should_receive(:page_download_instructions).with('pepsi', 2, 'cookies').and_return(stub)
    subject.search('pepsi')
    subject.each_search_results_page(&block)
  end
end
