require 'tort/ctm/mark_parser'

describe Tort::CTM::MarkParser do
  context 'when parsing texual mark' do
    it 'parses mark attributes' do
      mark = mock(:Mark)
      mark.should_receive(:name=).with("PEPSI LIGHT")
      #mark.should_receive(:registration_number=).with("000105858")
      mark.should_receive(:owner=).with("PEPSICO, INC.")
      mark.should_receive(:application_number=).with("000105858")
      mark.should_receive(:application_date=).with("01.04.1996")
      mark.should_receive(:registration_date=).with("28.10.1998")
      mark.should_receive(:classes=).with("32")
      mark.should_receive(:products_and_services=).with("Beer, ale and porter; mineral and aerated waters and other non-alcoholic drinks; syrups and other preparations for making beverages.")
      mark.should_receive(:valid_until=).with("01.04.2016")
      mark.should_receive(:status=).with('Registered')
      subject.parse(File.read('spec/fixtures/ctm/textual_mark.html'), mark)
    end
  end

  context 'when parsing visual mark' do
    it 'parses mark attributes' do
      mark = mock(:Mark)
      mark.should_receive(:name=).with('PEPSI DIET')
      mark.should_receive(:illustration_url=).with("http://oami.europa.eu:80/CTMOnline/RequestManager/getMarkAttachment?idMarkAttach=000000807824.JPG")
      #mark.should_receive(:registration_number=).with("")
      mark.should_receive(:owner=).with("PEPSICO, INC.")
      mark.should_receive(:application_number=).with("000105437")
      mark.should_receive(:application_date=).with("01.04.1996")
      mark.should_receive(:registration_date=).with("25.05.1998")
      mark.should_receive(:classes=).with("32")
      mark.should_receive(:products_and_services=).with("Beers; mineral and aerated waters and other non-alcoholic drinks; fruit drinks and fruit juices; syrups and other preparations for making beverages.")
      mark.should_receive(:valid_until=).with("01.04.2006")
      mark.should_receive(:status=).with('Registration expired')
      subject.parse(File.read('spec/fixtures/ctm/visual_mark.html'), mark)
    end
  end

  it 'returns the mark' do
    mark = double(:Hit).as_null_object
    subject.parse(File.read('spec/fixtures/ctm/visual_mark.html'), mark).should == mark
  end
end
