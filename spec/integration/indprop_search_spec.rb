require 'indprop_search'
require 'vcr_helper'

describe "Indprop search" do
  it 'fetches results for the given query and page number' do
    VCR.use_cassette("indprop") do
      results = IndpropSearch.search("eset", 1)
      results.hits.should have(10).marks
      results.hits.first.registration_number.should == "219039"
      results.hits.last.registration_number.should == "214095"
      results.next_page_number.should == 2
    end
  end
end
