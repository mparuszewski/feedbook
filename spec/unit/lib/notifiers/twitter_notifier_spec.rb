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
    let(:client) { double }

    it 'create and send notification message to notifier' do
      allow(subject).to receive(:nil?).and_return(true)
      expect(client).to receive(:update).with('message')
      
      allow(subject).to receive(:client).and_return(client)

      subject.notify('message')
    end
  end

end
