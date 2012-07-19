# encoding: utf-8
require 'tort/ctm/list_parser'

describe Tort::CTM::ListParser do

  it 'parses the HTML and extracts all hits' do
    download_instructions = subject.parse_download_instructions(File.read('spec/fixtures/ctm/pepsi.html'), stub.as_null_object)
    download_instructions.should have(20).instructions
  end

  it 'parses the HTML and extracts correct download instructions' do
    factory = mock(:Factory)
    factory.should_receive(:new).with('010909026')
    factory.should_receive(:new).exactly(19).times
    subject.parse_download_instructions(File.read('spec/fixtures/ctm/pepsi.html'), factory)
  end

  it 'returns the download instructions' do

  end

  it 'knows when there is next page' do
    subject.parse_download_instructions(File.read('spec/fixtures/ctm/pepsi.html'), stub.as_null_object)
    subject.should have_next_page
  end

  it 'knows when there is no next page' do
    subject.parse_download_instructions(File.read('spec/fixtures/ctm/pepsi_no_next_link.html'), stub.as_null_object)
    subject.should_not have_next_page
  end
end
