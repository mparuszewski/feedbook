require 'spec_helper'

describe Feedbook::Notifiers::FacebookNotifier do
  
  let(:hash) do
    {
      'token' => 'token123'
    }
  end

  subject { Feedbook::Notifiers::FacebookNotifier.instance }
  
  describe '#load_configuration' do
    it 'parses configuration hash and creates client instance' do
      expect(Koala::Facebook::API).to receive(:new).with('token123')
      subject.load_configuration(hash)
    end
  end

  describe '#notify' do
    
    let(:client) { double }

    it 'create and send notification message to notifier' do
      allow(subject).to receive(:nil?).and_return(true)
      expect(client).to receive(:put_wall_post).with('message')
      
      allow(subject).to receive(:client).and_return(client)
      
      subject.notify('message')
    end
  end

end
