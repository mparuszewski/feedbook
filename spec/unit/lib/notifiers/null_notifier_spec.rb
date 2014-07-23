require 'spec_helper'

describe Feedbook::Notifiers::NullNotifier do

  subject { Feedbook::Notifiers::NullNotifier.instance }
  
  describe '#load_configuration' do
    it 'parses configuration hash and creates client instance' do
      subject.load_configuration(hash)
    end
  end

  describe '#notify' do
    it 'create and send notification message to notifier' do
      subject.notify('message')
    end
  end

end
