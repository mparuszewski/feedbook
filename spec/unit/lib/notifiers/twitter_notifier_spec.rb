require 'spec_helper'

describe Feedbook::Notifiers::TwitterNotifier do
  
  let(:hash) do
    {
      'consumer_key' => 'ck',
      'consumer_secret' => 'cs',
      'access_token' => 'at',
      'access_token_secret' => 'ats'
    }
  end

  subject { Feedbook::Notifiers::TwitterNotifier.instance }
  
  describe '#load_configuration' do
    it 'parses configuration hash and creates client instance' do
      expect(Twitter::REST::Client).to receive(:new)
      subject.load_configuration(hash)
    end
  end

  describe '#notify' do
    it 'create and send notification message to notifier' do
      expect(subject).to receive_message_chain(:client, update: 'message')
      
      subject.notify('message')
    end
  end

end
