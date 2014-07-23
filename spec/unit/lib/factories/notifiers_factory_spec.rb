require 'spec_helper'

describe Feedbook::Factories::NotifiersFactory do

  describe '#create' do

    context 'FacebookNotifier' do
      it { expect(Feedbook::Factories::NotifiersFactory.create('facebook')).to  be(Feedbook::Notifiers::FacebookNotifier.instance) }
      it { expect(Feedbook::Factories::NotifiersFactory.create(:facebook)).to  be(Feedbook::Notifiers::FacebookNotifier.instance) }
    end

    context 'IRCNotifier' do
      it { expect(Feedbook::Factories::NotifiersFactory.create('irc')).to  be(Feedbook::Notifiers::IRCNotifier.instance) }
      it { expect(Feedbook::Factories::NotifiersFactory.create(:irc)).to  be(Feedbook::Notifiers::IRCNotifier.instance) }
    end

    context 'NullNotifier' do
      it { expect(Feedbook::Factories::NotifiersFactory.create('null')).to  be(Feedbook::Notifiers::NullNotifier.instance) }
      it { expect(Feedbook::Factories::NotifiersFactory.create(:null)).to  be(Feedbook::Notifiers::NullNotifier.instance) }
    end

    context 'TwitterNotifier' do
      it { expect(Feedbook::Factories::NotifiersFactory.create('twitter')).to  be(Feedbook::Notifiers::TwitterNotifier.instance) }
      it { expect(Feedbook::Factories::NotifiersFactory.create(:twitter)).to  be(Feedbook::Notifiers::TwitterNotifier.instance) }
    end

  end
end
