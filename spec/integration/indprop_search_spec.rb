require 'tort/indprop'
require 'vcr_helper'

describe "Indprop search" do
  it 'fetches results for the given query and page number' do
    VCR.use_cassette("indprop_eset") do
      marks = Tort::Indprop.search("*eset*", 1)
      marks.should have(10).marks
      marks.first.registration_number.should == "219039"
      marks.last.registration_number.should == "214095"
    end
  end

  it 'discards marks that are not valid' do
    VCR.use_cassette("indprop_pepsi") do
      marks = Tort::Indprop.search("pepsi", 1)
      marks.should have(1).mark
      marks.first.application_number.should == "362-2012"
    end
  end
end
