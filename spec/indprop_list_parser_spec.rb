require 'indprop_list_parser'

describe IndpropListParser do

  let(:parser) { parser = IndpropListParser.new }

  it 'parses the HTML and extracts hits' do
    factory = mock(:Factory)
    factory.should_receive(:new).with(detail_url: "http://registre.indprop.gov.sk/registre/detail/popup.do?register=oz&puv_id=82736")
    factory.should_receive(:new).with(detail_url: "http://registre.indprop.gov.sk/registre/detail/popup.do?register=oz&puv_id=73576")
    factory.should_receive(:new).exactly(8).times
    parser.parse(File.read('spec/fixtures/eset.html'), factory)
  end

  it 'returns next page number' do
    parser.parse(File.read('spec/fixtures/eset.html'), stub.as_null_object)
    parser.next_page_number.should == 2
  end

  it 'returns nil when there is no next page' do
    parser.parse(File.read('spec/fixtures/eset_no_next_link.htm'), stub.as_null_object)
    parser.next_page_number.should be_nil
  end
end
