require 'tort/ctm'
require 'vcr_helper'

describe "CTM search" do
  it 'fetches results for the given query and page number' do
    VCR.use_cassette("ctm_pepsi_1") do
      marks = Tort::CTM.search("pepsi", 1)
      marks.should have(20).marks
      marks.first.application_number.should == "010909026"
      marks.last.application_number.should == "004104998"
    end
  end

  it 'searches even beyond the first page' do
    VCR.use_cassette("ctm_pepsi_2") do
      marks = Tort::CTM.search("pepsi", 2)
      marks.collect(&:application_number).should =~
      [
        "003994811", "003613007", "003449121", "003449063", "003448966",
        "002967735", "002967719", "002967214", "002967164", "002744225",
        "002334605", "000991224", "000563163", "000106179"
      ]
    end
  end

  it 'fetches correct marks for different search' do
    VCR.use_cassette("ctm_nike") do
      marks = Tort::CTM.search("nike", 1)
      marks.should have(20).marks
      marks.first.application_number.should == "011003621"
      marks.last.application_number.should == "009729773"
    end
  end
end
