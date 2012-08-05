#encoding: utf-8
require 'tort/indprop'
require 'vcr_helper'

describe "Indprop search" do
  it 'finds all search results' do
    first_call = true
    all_results_fetched = false
    VCR.use_cassette('indprop_nike') do
      Tort::Indprop.search("nike") do |results|
        if first_call
          results.size.should == 7
          results.source.should == "Indprop"
          results.total.should == 16
          results.hits.collect(&:name).should include("acg", "JUST DO IT", "NIKE AIR")
          results.hits.collect(&:name).should_not include("nike ALPHA PROJECT")

          first_call = false
        else
          results.size.should == 4
          results.source.should == "Indprop"
          results.total.should == 16
          results.hits.collect(&:name).should include("NIKÉ", "NIKE")
          all_results_fetched = true
        end
      end

      all_results_fetched.should be_true
    end
  end

  it 'calls the block with no search results if no search results were found' do
    VCR.use_cassette('indprop_cbble') do
      block_called = false
      Tort::Indprop.search('cbble') do |results|
        results.size.should == 0
        results.total.should == 0
        results.hits.should be_empty
        block_called = true
      end
      block_called.should be_true
    end
  end
end
