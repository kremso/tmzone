require 'tort/indprop'
require 'vcr_helper'

describe "CTM search" do
  it 'finds all search results' do
    first_call = true
    all_results_fetched = false
    VCR.use_cassette('indprop_eset') do
      Tort::Indprop.search("eset") do |results|
        if first_call
          results.size.should == 10
          results.source.should == "Indprop"
          results.total.should == 17
          results.hits.collect(&:name).should include("Eset Smart Security", "VIRUS RADAR")

          first_call = false
        else
          results.size.should == 7
          results.source.should == "Indprop"
          results.total.should == 17
          results.hits.collect(&:name).should include("NOD32", "eset softwae")
          all_results_fetched = true
        end
      end

      all_results_fetched.should be_true
    end
  end
end
