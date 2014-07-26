require 'spec_helper'

describe Feedbook::Notifiers::MailNotifier do
  
  let(:hash) do
    {
      'address'              => 'address',
      'port'                 => 'port',
      'domain'               => 'domain',
      'username'             => 'username',
      'password'             => 'password',
      'authentication'       => 'authentication',
      'enable_starttls_auto' => 'enable_starttls_auto',
      'to'                   => 'to',
      'from'                 => 'from',
      'subject'              => 'subject'
    }
  end

  subject { Feedbook::Notifiers::MailNotifier.instance }
  
  describe '#load_configuration' do
    it 'parses configuration hash and saves settings' do
      expect(Mail).to receive(:defaults)
      subject.load_configuration(hash)
    end
  end

  describe '#notify' do

    it 'create and send notification message to notifier' do
      expect(Mail).to receive(:deliver)
      subject.load_configuration(hash)

      subject.notify('message')
    end
  end

end
