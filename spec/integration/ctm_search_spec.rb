require 'tort/ctm'
require 'vcr_helper'

describe "CTM search" do
  first_call, second_call = true, false
  it 'finds all search results' do
    VCR.use_cassette('ctm_ditec') do
      Tort::CTM.search("ditec") do |results|
        if first_call
          results.size.should == 20
          results.source.should == "CTM"
          results.total.should == 46
          results.hits.collect(&:name).should include("HIDITEC DESIGNING TECHNOLOGY", "CANDITECT")

          first_call = false
          second_call = true
        elsif second_call
          results.size.should == 20
          results.source.should == "CTM"
          results.total.should == 46
          results.hits.collect(&:name).should include("YUDITEC", "MEDITECH")

          second_call = false
        else
          results.size.should == 6
          results.source.should == "CTM"
          results.total.should == 46
          results.hits.collect(&:name).should include("kiditec", "DITEC")
        end
      end
    end
  end
end
