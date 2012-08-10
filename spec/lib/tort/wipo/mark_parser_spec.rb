require 'tort/wipo/mark_parser'

describe Tort::Wipo::MarkParser do
  context 'when parsing texual mark' do
    it 'parses mark attributes' do
      mark = mock(:Mark)
      mark.should_receive(:name=).with("ESET SMARTEST SECURITY")
      mark.should_receive(:registration_number=).with("2009/42 Gaz")
      mark.should_receive(:owner=).with("ESET, spol. s r.o.")
      mark.should_receive(:application_number=).with("007481575")
      mark.should_receive(:application_date=).with(Date.parse("19.12.2008"))
      mark.should_receive(:registration_date=).with(Date.parse("28.05.2009"))
      mark.should_receive(:add_class).with("09", "Computer software; computer software for data protection; data processing apparatus and equipment; computers and parts therefore; computer accessories; computer peripheral devices.")
      mark.should_receive(:add_class).with("38", "Communications by computer terminals; transmission of messages and images by computer.")
      mark.should_receive(:add_class).with("41", "Provision of on-line electronic publications (not downloadable); publication of books and magazines in electronic form; publishing texts in electronic form (except advertising and recruitment texts).")
      mark.should_receive(:add_class).with("42", "Creating and developing computer software, in particular data protection software; providing computer software; consultancy and expert services regarding computer software; providing of information relating to computer software; rental of computers and peripheral equipment for computers; specialist consultancy in the field of computers, computer programs and data processing equipment.")
      mark.should_receive(:valid_until=).with(Date.parse("28.05.2019"))
      # mark.should_receive(:status=).with('Registered')
      subject.parse(File.read('spec/fixtures/wipo/textual_mark.html'), mark)
    end
  end

  context 'when parsing visual mark' do
    it 'parses mark attributes' do
      mark = mock(:Mark)
      mark.should_receive(:name=).with('NIVEA FOR MEN MENERGY REBELLIOUS')
      mark.should_receive(:illustration_url=).with("http://www.wipo.int/romarin/images/10/00/1000482.jpg")
      mark.should_receive(:registration_number=).with("2009/19 Gaz")
      mark.should_receive(:owner=).with("Beiersdorf AG")
      # mark.should_receive(:application_number=).with("")
      # mark.should_receive(:application_date=).with("")
      mark.should_receive(:registration_date=).with(Date.parse("17.03.2009"))
      mark.should_receive(:add_class).with("03", "Soaps; perfumery, essential oils; preparations for body and beauty care; preparations for the cleansing, care and embellishment of the hair; deodorants and anti-perspirants for personal use.")
      mark.should_receive(:valid_until=).with(Date.parse("17.03.2019"))
      # mark.should_receive(:status=).with('Registration expired')
      subject.parse(File.read('spec/fixtures/wipo/visual_mark.html'), mark)
    end
  end

  it 'parses full mark name even if it contains dash' do
    mark = mock(:Mark).as_null_object
    mark.should_receive(:name=).with('CS b BIO-ACTIVE')
    subject.parse(File.read('spec/fixtures/wipo/mark_with_dash.html'), mark)
  end

  it 'returns the mark' do
    mark = double(:Hit).as_null_object
    subject.parse(File.read('spec/fixtures/wipo/visual_mark.html'), mark).should == mark
  end
end
