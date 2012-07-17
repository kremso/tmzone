require 'tort/search_results_extraction_strategy'

describe Tort::SearchResultsExtractionStrategy do
  let(:list_parser) { mock(:ListParser) }
  let(:hit_fetching_strategy) { mock(:HitFetchingStrategy) }

  subject { Tort::SearchResultsExtractionStrategy.new(list_parser, hit_fetching_strategy) }

  before do
    list_parser.stub(parse_download_instructions: [stub])
    hit_fetching_strategy.stub(fetch_hits: [stub])
  end

  it 'returns details about search hits' do
    instructions = [stub]
    hits = [stub]
    list_parser.stub(parse_download_instructions: instructions)
    hit_fetching_strategy.should_receive(:fetch_hits).with(instructions)
    hit_fetching_strategy.stub(hits: hits)
    subject.process_search_results('html')
    subject.hits.should == hits
  end

  it 'returns next page number' do
    list_parser.stub(next_page_number: 2)
    subject.process_search_results('html')
    subject.next_page_number.should == 2
  end

  it 'knows if a results list has next page' do
    list_parser.stub(has_next_page?: true)
    subject.process_search_results('html')
    subject.should have_next_page
  end
end
