require 'tort/download_instructions'

describe Tort::DownloadInstructions do
  context 'when constructed' do
    it 'sets its attributes according to the params hash' do
      instructions = Tort::DownloadInstructions.new(url: 'foo', params: {q: 'q'}, cookies: 'cookies', method: 'POST')
      instructions.url.should == 'foo'
      instructions.params.should == {q: 'q'}
      instructions.cookies.should == 'cookies'
      instructions.method.should == 'POST'
    end
  end
end
