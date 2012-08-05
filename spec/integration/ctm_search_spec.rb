require 'tort/ctm'
require 'vcr_helper'

describe "CTM search" do
  first_call, second_call = true, false
  all_results_fetched = false

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
          results.size.should == 11
          results.source.should == "CTM"
          results.total.should == 46
          results.hits.collect(&:name).should include("YUDITEC", "MEDITECH")
          results.hits.collect(&:name).should_not include("EURO-MEDITECH COMFORT")

          second_call = false
        else
          results.size.should == 4
          results.source.should == "CTM"
          results.total.should == 46
          results.hits.collect(&:name).should include("kiditec", "BENDITEC")
          results.hits.collect(&:name).should_not include("DITECnology")

          all_results_fetched = true
        end
      end

      all_results_fetched.should be_true
    end
  end
end
