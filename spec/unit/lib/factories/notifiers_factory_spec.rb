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

    context 'MailNotifier' do
      it { expect(Feedbook::Factories::NotifiersFactory.create('mail')).to  be(Feedbook::Notifiers::MailNotifier.instance) }
      it { expect(Feedbook::Factories::NotifiersFactory.create(:mail)).to  be(Feedbook::Notifiers::MailNotifier.instance) }
    end

    context 'NullNotifier' do
      it { expect(Feedbook::Factories::NotifiersFactory.create('null')).to  be(Feedbook::Notifiers::NullNotifier.instance) }
      it { expect(Feedbook::Factories::NotifiersFactory.create(:null)).to  be(Feedbook::Notifiers::NullNotifier.instance) }
    end

    context 'TwitterNotifier' do
      it { expect(Feedbook::Factories::NotifiersFactory.create('twitter')).to  be(Feedbook::Notifiers::TwitterNotifier.instance) }
      it { expect(Feedbook::Factories::NotifiersFactory.create(:twitter)).to  be(Feedbook::Notifiers::TwitterNotifier.instance) }
    end

    context 'Notifier is not defined in Factory' do
      context 'and Notifier exists as TestNotifier' do
        before :each do
          expect(Feedbook::Notifiers).to receive(:const_defined?).with('SuperTestNotifier').and_return(true)
          expect(Feedbook::Notifiers).to receive(:const_get).with('SuperTestNotifier').and_return(Feedbook::Notifiers::NullNotifier)
        end

        it 'returns instance of given Notifier' do
          expect(Feedbook::Factories::NotifiersFactory.create('super_test')).to  be(Feedbook::Notifiers::NullNotifier.instance)
        end
      end

      context 'and Notifier exists as TestNotifier' do
        before :each do
          expect(Feedbook::Notifiers).to receive(:const_defined?).with('TestNotifier').and_return(true)
          expect(Feedbook::Notifiers).to receive(:const_get).with('TestNotifier').and_return(Feedbook::Notifiers::NullNotifier)
        end

        it 'returns instance of given Notifier' do
          expect(Feedbook::Factories::NotifiersFactory.create('test')).to  be(Feedbook::Notifiers::NullNotifier.instance)
        end
      end

      context 'and Notifier exists as TESTNotifier' do
        before :each do
          expect(Feedbook::Notifiers).to receive(:const_defined?).with('TestNotifier').and_return(false)
          expect(Feedbook::Notifiers).to receive(:const_defined?).with('TESTNotifier').and_return(true)
          expect(Feedbook::Notifiers).to receive(:const_get).with('TESTNotifier').and_return(Feedbook::Notifiers::NullNotifier)
        end

        it 'returns instance of given Notifier' do
          expect(Feedbook::Factories::NotifiersFactory.create('test')).to  be(Feedbook::Notifiers::NullNotifier.instance)
        end
      end

      context 'and Notifier does not exist' do
        before :each do
          expect(Feedbook::Notifiers).to receive(:const_defined?).with('TestNotifier').and_return(false).twice
          expect(Feedbook::Notifiers).to receive(:const_defined?).with('TESTNotifier').and_return(false)
        end

        it 'does nothing' do
          expect(Feedbook::Factories::NotifiersFactory.create('test')).to   be(nil)
        end
      end
    end

  end
end
