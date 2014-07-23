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
    it 'create and send notification message to notifier' do
      expect(subject).to receive_message_chain(:client, put_wall_post: 'message')
      
      subject.notify('message')
    end
  end

end
