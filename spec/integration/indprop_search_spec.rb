require 'indprop/indprop'
require 'vcr_helper'

describe "Indprop search" do
  it 'fetches results for the given query and page number' do
    VCR.use_cassette("indprop_eset") do
      marks = Indprop.search("*eset*")
      marks.should have(10).marks
      marks.first.registration_number.should == "219039"
      marks.last.registration_number.should == "214095"
    end
  end

  it 'discards marks that are not valid' do
    VCR.use_cassette("indprop_pepsi") do
      marks = Indprop.search("pepsi")
      marks.should have(1).mark
      marks.first.application_number.should == "362-2012"
    end
  end
end
