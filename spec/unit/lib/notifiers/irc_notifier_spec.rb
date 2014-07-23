require 'spec_helper'

describe Feedbook::Notifiers::IRCNotifier do
  
  let(:hash) do
    {
      'url'         => 'url',
      'port'        => 'port',
      'ssl_enabled' => 'ssl',
      'channel'     => 'channel',
      'nick'        => 'nick'
    }
  end

  subject { Feedbook::Notifiers::IRCNotifier.instance }
  
  describe '#load_configuration' do
    it 'parses configuration hash and creates client instance' do
      expect(IrcNotify::Client).to receive(:build).with('url', 'port', ssl: 'ssl')
      subject.load_configuration(hash)
    end
  end

  describe '#notify' do
    let(:client) { double }

    it 'create and send notification message to notifier' do
      expect(IrcNotify::Client).to receive(:build).with('url', 'port', ssl: 'ssl')
      subject.load_configuration(hash)

      allow(subject).to receive(:client).and_return(client)

      expect(client).to receive(:register).with('nick')
      expect(client).to receive(:notify).with('message')
      expect(client).to receive(:quit)
      
      subject.notify('message')
    end
  end

end
