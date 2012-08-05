# encoding: utf-8
require 'tort/mark_validity_filter'

describe Tort::MarkValidityFilter do
  let(:list_parser) { mock(:ListParser) }
  let(:factory) { mock(:Factory) }

  it 'forwards all parameters to the decorated parser' do
    filter = Tort::MarkValidityFilter.new(list_parser, {})
    list_parser.should_receive(:hits_download_instructions).with(factory).and_return([])
    filter.hits_download_instructions(factory)
  end

  it 'forwards all methods' do
    filter = Tort::MarkValidityFilter.new(list_parser, {})
    list_parser.should_receive(:parse)
    filter.parse
  end

  it 'allows specified marks' do
    filter = Tort::MarkValidityFilter.new(list_parser, {"v konaní" => true})
    instruction = stub(preparse: { status: "v konaní" })
    list_parser.stub(hits_download_instructions: [instruction])
    filter.hits_download_instructions(factory).should == [instruction]
  end

  it 'rejects marks that were not specified' do
    filter = Tort::MarkValidityFilter.new(list_parser, {"v konaní" => true})
    instruction = stub(preparse: { status: "zamietnutá" })
    list_parser.stub(hits_download_instructions: [instruction])
    filter.hits_download_instructions(factory).should == []
  end
end
