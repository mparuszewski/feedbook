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
      allow(configuration).to receive(:load_notifiers)
      feeds.each do |feed|
        expect(feed).to receive(:fetch)
        expect(feed).to receive(:valid?)
      end

      expect(Object).to receive(:every).with(300).and_return(300)

      subject.start('feedbook.yml')
    end
  end
end
