require 'spec_helper'

describe Feedbook::LiquidExtensions::Filters::GooglShortenerFilter do
  
  describe '#googl' do
    before :each do
      allow(Googl).to receive(:shorten).with('https://github.com/pinoss').and_return(OpenStruct.new(short_url: 'http://goo.gl/jExQ6W'))
    end

    it 'converts given link into shorten form by Googl API service' do
      class TestClass
        include Feedbook::LiquidExtensions::Filters::GooglShortenerFilter
      end

      expect(TestClass.new.googl('https://github.com/pinoss')).to eq('http://goo.gl/jExQ6W')
    end
  end
end
