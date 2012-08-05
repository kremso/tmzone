require 'tort/wipo'

require 'vcr_helper'

describe "WIPO search" do
  it "finds all search results" do
    VCR.use_cassette("wipo_bio") do
      first_call = true
      all_results_fetched = false
      Tort::Wipo.search("bio") do |results|
        if first_call
          results.size.should == 25
          results.source.should == "WIPO"
          results.total.should == 38
          results.hits.collect(&:name).should include("bio", "Bio Believe", "OVKO Bio", "BIO Mamma")

          first_call = false
        else
          results.size.should == 13
          results.source.should == "WIPO"
          results.total.should == 38
          results.hits.collect(&:name).should include("BIO GOURMET", "CS b BIO-ACTIVE")

          all_results_fetched = true
        end
      end
      all_results_fetched.should be_true
    end
  end

  it 'calls the block with no search results if no search results were found' do
    VCR.use_cassette('wipo_cbble') do
      block_called = false
      Tort::Wipo.search('cbble') do |results|
        results.size.should == 0
        results.total.should == 0
        results.hits.should be_empty
        block_called = true
      end
      block_called.should be_true
    end
  end
end
