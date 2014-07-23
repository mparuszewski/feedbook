require 'spec_helper'

describe Feedbook::Feed do
  
  let(:hash) do
    {
      urls:           'http://blog.test.lo/blog http://blog.test.lo/blog2',
      notifications:  [
        { 'type' => 'twitter',  'template' => '{{ test_variable }} POST'   }, 
        { 'type' => 'facebook', 'template' => '{{ test_variable }} POST 2' }
      ],
      variables:      { 'test_variable' => 'test_value' }
    }
  end

  subject { Feedbook::Feed.new(hash) } 
  
  describe '#initialize' do

    it 'parses hash and creates Feed instance' do
      expect(subject.urls).to      eq(['http://blog.test.lo/blog', 'http://blog.test.lo/blog2'])
      expect(subject.variables).to eq({ 'test_variable' => 'test_value' })
    end
  
    it 'should raise Errors::InvalidIntervalFormatError if interval parameter is missing' do
      expect(Feedbook::Feed.new({}).urls).to          eq([])
      expect(Feedbook::Feed.new({}).notifications).to eq([])
      expect(Feedbook::Feed.new({}).variables).to     eq({})
    end
  end

  describe '#fetch' do

    it 'should send fetch_and_parse to Feedjira::Feed' do
      allow(Feedjira::Feed).to  receive(:fetch_and_parse).with('http://blog.test.lo/blog').and_return([])
      allow(Feedjira::Feed).to  receive(:fetch_and_parse).with('http://blog.test.lo/blog2').and_return([])

      expect(subject.fetch).to eq([])
    end
  end

end
