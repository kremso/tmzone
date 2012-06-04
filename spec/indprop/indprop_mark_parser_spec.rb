#encoding: utf-8

require 'indprop/indprop_mark_parser'

describe IndpropMarkParser do
  context 'when parsing texual mark' do
    it 'parses mark attributes' do
      mark = mock(:Hit)
      mark.should_receive(:name=).with("ESET")
      mark.should_receive(:registration_number=).with("202097")
      mark.should_receive(:owner=).with("ESET, spol. s r. o.; Einsteinova 24; 851 01 Bratislava; SK")
      mark.should_receive(:application_number=).with("2984-2002")
      mark.should_receive(:application_date=).with("18.10.2002")
      mark.should_receive(:registration_date=).with("05.03.2003")
      mark.should_receive(:classes=).with("9, 16, 42")
      mark.should_receive(:products_and_services=).with("9 - Počítačové softvéry; počítačové softvéry na ochranu dát. 16 - Tlačoviny reklamného a informačného charakteru; sprievodca pre používateľov softvéru. 42 - Tvorba a výroba počítačových softvérov, a to najmä počítačových softvérov na ochranu dát; poskytovanie softvérov; poradenské, konzultačné a expertízne služby v oblasti počítačových softvérov.")
      mark.should_receive(:valid_until=).with("18.10.2012")
      IndpropMarkParser.parse(File.read('spec/fixtures/textual_mark.htm'), mark)
    end
  end

  context 'when parsing visual mark' do
    it 'parses mark attributes' do
      mark = mock(:Hit)
      mark.should_receive(:illustration_url=).with("http://registre.indprop.gov.sk/registre/obrazky/znamky/2007/2007005274.jpg")
      mark.should_receive(:registration_number=).with("219039")
      mark.should_receive(:owner=).with("ESET, spol. s r. o.; Einsteinova 24; 851 01 Bratislava; SK")
      mark.should_receive(:application_number=).with("5274-2007")
      mark.should_receive(:application_date=).with("13.03.2007")
      mark.should_receive(:registration_date=).with("13.09.2007")
      mark.should_receive(:classes=).with("9, 38, 41, 42")
      mark.should_receive(:products_and_services=).with("9 - Počítačové softvéry; počítačové softvéry na ochranu dát; stroje a zariadenia na spracovanie údajov; počítače a ich časti; počítačové príslušenstvo; periférne zariadenia počítačov. 38 - Počítačová komunikácia, prenos správ a obrazových informácií pomocou počítača, telegrafická komunikácia. 41 - Poskytovanie elektronických publikácií online bez možnosti kopírovania, vydávanie kníh a časopisov v elektronickej forme, vydávanie textov v elektronickej forme s výnimkou vydávania reklamných a náborových textov. 42 - Tvorba, výroba a vývoj počítačových softvérov, a to najmä počítačových softvérov na ochranu dát; poskytovanie softvérov; poradenské, konzultačné a expertízne služby v oblasti počítačových softvérov; poskytovanie informácií v oblasti počítačových softvérov; prenájom počítačov a príslušenstva k počítačom; odborné poradenstvo v oblasti počítačov, počítačových programov a v oblasti zariadení na spracovanie dát.")
      mark.should_receive(:valid_until=).with("13.03.2017")
      IndpropMarkParser.parse(File.read('spec/fixtures/visual_mark.htm'), mark)
    end
  end

  it 'returns the mark' do
      mark = double(:Hit).as_null_object
      IndpropMarkParser.parse(File.read('spec/fixtures/visual_mark.htm'), mark).should == mark
  end

end
