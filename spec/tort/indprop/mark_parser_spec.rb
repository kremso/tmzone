#encoding: utf-8

require 'tort/indprop/mark_parser'

describe Tort::Indprop::MarkParser do
  context 'when parsing texual mark' do
    it 'parses mark attributes' do
      mark = mock(:Hit, status: 'status')
      mark.should_receive(:name=).with("ESET")
      mark.should_receive(:registration_number=).with("202097")
      mark.should_receive(:owner=).with("ESET, spol. s r. o.; Einsteinova 24; 851 01 Bratislava; SK")
      mark.should_receive(:application_number=).with("2984-2002")
      mark.should_receive(:application_date=).with("18.10.2002")
      mark.should_receive(:registration_date=).with("05.03.2003")
      mark.should_receive(:add_class).with("9", "Počítačové softvéry; počítačové softvéry na ochranu dát.")
      mark.should_receive(:add_class).with("16", "Tlačoviny reklamného a informačného charakteru; sprievodca pre používateľov softvéru.")
      mark.should_receive(:add_class).with("42", "Tvorba a výroba počítačových softvérov, a to najmä počítačových softvérov na ochranu dát; poskytovanie softvérov; poradenské, konzultačné a expertízne služby v oblasti počítačových softvérov.")
      mark.should_receive(:valid_until=).with("18.10.2012")
      mark.should_receive(:status=).with('Platná')
      subject.parse(File.read('spec/fixtures/indprop/textual_mark.htm'), mark)
    end
  end

  context 'when parsing visual mark' do
    it 'parses mark attributes' do
      mark = mock(:Hit, status: 'status')
      mark.should_receive(:illustration_url=).with("http://registre.indprop.gov.sk/registre/obrazky/znamky/2007/2007005274.jpg")
      mark.should_receive(:registration_number=).with("219039")
      mark.should_receive(:owner=).with("ESET, spol. s r. o.; Einsteinova 24; 851 01 Bratislava; SK")
      mark.should_receive(:application_number=).with("5274-2007")
      mark.should_receive(:application_date=).with("13.03.2007")
      mark.should_receive(:registration_date=).with("13.09.2007")
      mark.should_receive(:add_class).with("9", "Počítačové softvéry; počítačové softvéry na ochranu dát; stroje a zariadenia na spracovanie údajov; počítače a ich časti; počítačové príslušenstvo; periférne zariadenia počítačov.")
      mark.should_receive(:add_class).with("38", "Počítačová komunikácia, prenos správ a obrazových informácií pomocou počítača, telegrafická komunikácia.")
      mark.should_receive(:add_class).with("41", "Poskytovanie elektronických publikácií online bez možnosti kopírovania, vydávanie kníh a časopisov v elektronickej forme, vydávanie textov v elektronickej forme s výnimkou vydávania reklamných a náborových textov.")
      mark.should_receive(:add_class).with("42", "Tvorba, výroba a vývoj počítačových softvérov, a to najmä počítačových softvérov na ochranu dát; poskytovanie softvérov; poradenské, konzultačné a expertízne služby v oblasti počítačových softvérov; poskytovanie informácií v oblasti počítačových softvérov; prenájom počítačov a príslušenstva k počítačom; odborné poradenstvo v oblasti počítačov, počítačových programov a v oblasti zariadení na spracovanie dát.")
      mark.should_receive(:valid_until=).with("13.03.2017")
      mark.should_receive(:status=).with('Platná')
      subject.parse(File.read('spec/fixtures/indprop/visual_mark.htm'), mark)
    end
  end

  context 'when parsing visual and text mark' do
    it 'extracts both name and image' do
      mark = mock(:Hit, status: 'status').as_null_object
      mark.should_receive(:illustration_url=).with("http://registre.indprop.gov.sk/registre/obrazky/znamky/1995/1995002072.jpg")
      mark.should_receive(:name=).with("eset softwae")
    subject.parse(File.read('spec/fixtures/indprop/visual_and_text.htm'), mark).should == mark
    end
  end

  it 'returns the mark' do
    mark = double(:Hit).as_null_object
    subject.parse(File.read('spec/fixtures/indprop/visual_mark.htm'), mark).should == mark
  end

  it 'parses status if the legal status is not available' do
    mark = double(:Hit, status: nil).as_null_object
    mark.should_receive(:status=).with('zverejnená')
    subject.parse(File.read('spec/fixtures/indprop/lays.html'), mark)
  end

end
