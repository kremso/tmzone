# encoding: utf-8
require 'tort/indprop/list_parser'

describe Tort::Indprop::ListParser do

  it 'parses the HTML and extracts hits with URLs and statuses' do
    factory = mock(:Factory)
    factory.should_receive(:new).with(url: "http://registre.indprop.gov.sk/registre/detail/popup.do?register=oz&puv_id=99251", method: 'POST')
    factory.should_receive(:new).with(url: "http://registre.indprop.gov.sk/registre/detail/popup.do?register=oz&puv_id=11156", method: 'POST')
    factory.should_receive(:new).with(url: "http://registre.indprop.gov.sk/registre/detail/popup.do?register=oz&puv_id=1498", method: 'POST')
    factory.should_receive(:new).with(url: "http://registre.indprop.gov.sk/registre/detail/popup.do?register=oz&puv_id=1490", method: 'POST')
    factory.should_receive(:new).with(url: "http://registre.indprop.gov.sk/registre/detail/popup.do?register=oz&puv_id=1296", method: 'POST')
    factory.should_receive(:new).with(url: "http://registre.indprop.gov.sk/registre/detail/popup.do?register=oz&puv_id=16070", method: 'POST')
    factory.should_receive(:new).with(url: "http://registre.indprop.gov.sk/registre/detail/popup.do?register=oz&puv_id=16062", method: 'POST')
    download_instructions = subject.parse_download_instructions(File.read('spec/fixtures/indprop/pepsi.htm'), factory)
    download_instructions.should have(7).instructions
  end

  it 'returns next page number' do
    subject.parse_download_instructions(File.read('spec/fixtures/indprop/eset.html'), stub.as_null_object)
    subject.next_page_number.should == 2
  end

  it 'returns nil when there is no next page' do
    subject.parse_download_instructions(File.read('spec/fixtures/indprop/eset_no_next_link.htm'), stub.as_null_object)
    subject.next_page_number.should be_nil
  end

  it 'knows when there is next page' do
    subject.parse_download_instructions(File.read('spec/fixtures/indprop/eset.html'), stub.as_null_object)
    subject.should have_next_page
  end

  it 'knows when there is no next page' do
    subject.parse_download_instructions(File.read('spec/fixtures/indprop/eset_no_next_link.htm'), stub.as_null_object)
    subject.should_not have_next_page
  end
end
