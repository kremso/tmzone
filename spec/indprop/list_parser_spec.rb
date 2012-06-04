# encoding: utf-8
require 'indprop/list_parser'

describe Indprop::ListParser do

  it 'parses the HTML and extracts hits with URLs and statuses' do
    factory = mock(:Factory)
    factory.should_receive(:new).with(detail_url: "http://registre.indprop.gov.sk/registre/detail/popup.do?register=oz&puv_id=99251", status: "v konaní")
    factory.should_receive(:new).with(detail_url: "http://registre.indprop.gov.sk/registre/detail/popup.do?register=oz&puv_id=11156", status: "Zaniknutá")
    factory.should_receive(:new).with(detail_url: "http://registre.indprop.gov.sk/registre/detail/popup.do?register=oz&puv_id=1498", status: "zastavená")
    factory.should_receive(:new).with(detail_url: "http://registre.indprop.gov.sk/registre/detail/popup.do?register=oz&puv_id=1490", status: "Zaniknutá")
    factory.should_receive(:new).with(detail_url: "http://registre.indprop.gov.sk/registre/detail/popup.do?register=oz&puv_id=1296", status: "Zaniknutá")
    factory.should_receive(:new).with(detail_url: "http://registre.indprop.gov.sk/registre/detail/popup.do?register=oz&puv_id=16070", status: "zamietnutá")
    factory.should_receive(:new).with(detail_url: "http://registre.indprop.gov.sk/registre/detail/popup.do?register=oz&puv_id=16062", status: "zamietnutá")
    hits, next_page_number = subject.parse(File.read('spec/fixtures/pepsi.htm'), factory)
    hits.should have(7).hits
  end

  it 'returns next page number' do
    hits, next_page_number = subject.parse(File.read('spec/fixtures/eset.html'), stub.as_null_object)
    next_page_number.should == 2
  end

  it 'returns nil when there is no next page' do
    hits, next_page_number = subject.parse(File.read('spec/fixtures/eset_no_next_link.htm'), stub.as_null_object)
    next_page_number.should be_nil
  end
end
