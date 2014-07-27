require 'spec_helper'

describe Feedbook::Listener do
  
  subject { Feedbook::Listener } 
  
  describe '#start' do

    let(:configuration) { double }
    let(:feeds) { [double, double, double] }

    before :each do
      allow(configuration).to receive(:interval).and_return(300)
      allow(subject).to receive(:load_configuration).with('feedbook.yml').and_return([feeds, configuration])
    end

    it 'parses hash and creates Feed instance' do
      expect(Feedbook::PluginsManager).to receive(:load_plugins).with('./plugins')

      allow(configuration).to receive(:load_notifiers)
      
      feeds.each do |feed|
        expect(feed).to receive(:fetch)
        expect(feed).to receive(:valid?)
      end

      expect(Object).to receive(:every).with(300).and_return(300)

      subject.start('feedbook.yml', './plugins')
    end
  end

  describe '#observe_and_notify' do

    let(:feed) do
      {
        posts: [OpenStruct.new(url: '1'), OpenStruct.new(url: '2')],
        feed: double
      }
    end

    let(:notifications) { [double, double] }

    before :each do
      expect(feed[:feed]).to receive(:fetch).and_return([OpenStruct.new(url: '1'), OpenStruct.new(url: '2'), OpenStruct.new(url: '3'), OpenStruct.new(url: '4')])
      expect(feed[:feed]).to receive(:notifications).twice.and_return(notifications)
    end

    it 'parses hash and creates Feed instance' do
      expect(Feedbook::Comparers::PostsComparer).to receive(:get_new_posts).with([OpenStruct.new(url: '1'), OpenStruct.new(url: '2')], [OpenStruct.new(url: '1'), OpenStruct.new(url: '2'), OpenStruct.new(url: '3'), OpenStruct.new(url: '4')]).and_return([OpenStruct.new(url: '3'), OpenStruct.new(url: '4')])
      notifications.each do |notification|
        expect(notification).to receive(:notify).with(OpenStruct.new(url: '3')).and_return(nil)
        expect(notification).to receive(:notify).with(OpenStruct.new(url: '4')).and_return(nil)
      end

      expect(subject.observe_and_notify(feed)[:posts]).to eq([OpenStruct.new(url: '1'), OpenStruct.new(url: '2'), OpenStruct.new(url: '3'), OpenStruct.new(url: '4')])
    end
  end
end
