require 'spec_helper'

describe Feedbook::Configuration do
  
  let(:hash) do
    {
      'twitter'  => {},
      'facebook' => {},
      'irc'      => {},
      'interval' => '5m'
    }
  end

  before :each do
    allow(Feedbook::Helpers::TimeIntervalParser).to receive(:parse).with('5m').and_return(300)
    allow(Feedbook::Helpers::TimeIntervalParser).to receive(:parse).with(nil).and_raise(Feedbook::Errors::InvalidIntervalFormatError.new)
  end

  subject { Feedbook::Configuration.new(hash) } 
  
  describe '#initialize' do

    it 'parses hash and creates Configuration instance' do
      expect(subject.interval).to eq(300)
    end
  
    it 'should raise Errors::InvalidIntervalFormatError if interval parameter is missing' do
      expect { Feedbook::Configuration.new({}) }.to raise_error(Feedbook::Errors::InvalidIntervalFormatError)
    end
  end

  describe '#load_notifiers' do

    it 'should return hash with Post parameters' do
      expect(Feedbook::Notifiers::TwitterNotifier).to  receive_message_chain(:instance, load_configuration: {}) { true }
      expect(Feedbook::Notifiers::FacebookNotifier).to receive_message_chain(:instance, load_configuration: {}) { true }
      expect(Feedbook::Notifiers::IRCNotifier).to      receive_message_chain(:instance, load_configuration: {}) { true }

      subject.load_notifiers
    end
  end

end