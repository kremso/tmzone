# encoding: utf-8
require 'tort/indprop/list_parser'

describe Tort::Indprop::ListParser do

  it 'parses the HTML and extracts hits with URLs and statuses' do
    factory = mock(:Factory)
    factory.should_receive(:new).with('/registre/detail/popup.do?register=oz&puv_id=99251', anything)
    factory.should_receive(:new).with('/registre/detail/popup.do?register=oz&puv_id=11156', anything)
    factory.should_receive(:new).with('/registre/detail/popup.do?register=oz&puv_id=1498', anything)
    factory.should_receive(:new).with('/registre/detail/popup.do?register=oz&puv_id=1490', anything)
    factory.should_receive(:new).with('/registre/detail/popup.do?register=oz&puv_id=1296', anything)
    factory.should_receive(:new).with('/registre/detail/popup.do?register=oz&puv_id=16070', anything)
    factory.should_receive(:new).with('/registre/detail/popup.do?register=oz&puv_id=16062', anything)
    subject.parse(File.read('spec/fixtures/indprop/pepsi.htm'))
    subject.hits_download_instructions(factory)
  end

  it 'returns the download instructions' do
    factory = stub.as_null_object
    subject.parse(File.read('spec/fixtures/indprop/pepsi.htm'))
    subject.hits_download_instructions(factory).should have(7).instructions
  end

  it 'returns download instructions for next page' do
    instructions = stub
    subject.parse(File.read('spec/fixtures/indprop/eset.html'))
    subject.next_page_download_instructions(instructions).should == instructions
  end

  it 'returns nil instead of download instructions when there is no next page' do
    instructions = stub
    subject.parse(File.read('spec/fixtures/indprop/eset_no_next_link.htm'))
    subject.next_page_download_instructions(instructions).should be_nil
  end

  it 'knows the total number of hits' do
    subject.parse(File.read('spec/fixtures/indprop/eset_no_next_link.htm'))
    subject.total_hits.should == 29
  end

  it 'parses the mark status and name' do
    factory = mock(:Factory)
    factory.should_receive(:new).with(anything, { status: 'v konaní', name: 'Lay´s KONEČNE CHIPSY'})
    factory.should_receive(:new).with(anything, { status: 'Zaniknutá', name: 'ASK FOR MORE'})
    factory.should_receive(:new).with(anything, { status: 'zastavená', name: 'PEPSI MUSIC'})
    factory.should_receive(:new).with(anything, { status: 'Zaniknutá', name: 'AQUA MINERALE'})
    factory.should_receive(:new).with(anything, { status: 'Zaniknutá', name: ''})
    factory.should_receive(:new).with(anything, { status: 'zamietnutá', name: 'SLOVAKIA chips'})
    factory.should_receive(:new).with(anything, { status: 'zamietnutá', name: 'Slovak CHIPS'})
    subject.parse(File.read('spec/fixtures/indprop/pepsi.htm'))
    subject.hits_download_instructions(factory)
  end
end
