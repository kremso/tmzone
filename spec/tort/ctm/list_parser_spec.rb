# encoding: utf-8
require 'tort/ctm/list_parser'

describe Tort::CTM::ListParser do

  it 'parses the HTML and extracts all hits' do
    subject.parse(File.read('spec/fixtures/ctm/pepsi.html'))
    subject.hits_download_instructions(stub.as_null_object).should have(20).instructions
  end

  it 'parses the HTML and extracts correct download instructions' do
    subject.parse(File.read('spec/fixtures/ctm/pepsi.html'))
    factory = mock(:Factory)
    factory.should_receive(:new).with(type: 'CTM', mark_id: '010909026')
    factory.should_receive(:new).exactly(19).times
    subject.hits_download_instructions(factory)
  end

  it 'extracts correct mark URLs' do
    subject.parse(File.read('spec/fixtures/ctm/multiple_mark_urls.html'))
    factory = mock(:Factory)
    factory.should_receive(:new).with(type: 'IR', mark_id: 'W00891116')
    factory.should_receive(:new).with(type: 'IR', mark_id: 'W00874338')
    factory.should_receive(:new).with(type: 'CTM', mark_id: '000684233')
    factory.should_receive(:new).with(type: 'CTM', mark_id: '000501411')
    factory.should_receive(:new).with(type: 'CTM', mark_id: '000423749')
    factory.should_receive(:new).with(type: 'CTM', mark_id: '000274696')
    subject.hits_download_instructions(factory)
  end

  it 'returns the download instructions if the search results have next page' do
    instructions = stub
    subject.parse(File.read('spec/fixtures/ctm/pepsi.html'))
    subject.next_page_download_instructions(instructions).should == instructions
  end

  it 'returns nil instead of download instructions when there is no next page' do
    subject.parse(File.read('spec/fixtures/ctm/pepsi_no_next_link.html'))
    subject.next_page_download_instructions(stub).should be_nil
  end

  it 'knows the total number of hits' do
    subject.parse(File.read('spec/fixtures/ctm/pepsi.html'))
    subject.total_hits.should == 54
  end
end
