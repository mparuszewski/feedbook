require 'spec_helper'

describe Feedbook::PluginsManager do
  
  describe '#load_plugins' do

    context 'when plugins directory exists' do
      before :each do
        expect(File).to receive(:directory?).with('./plugins').and_return(true)
        expect(File).to receive(:join).with('./plugins', '**', '*.rb').and_return('./plugins/**/.fb')
        expect(Dir).to  receive(:[]).with('./plugins/**/.fb').and_return(['time'])
        expect(Object).to receive(:require).with('time')
      end

      it 'requires all file inside plugins directory' do
        Feedbook::PluginsManager.load_plugins('./plugins')
      end
    end

    context 'when plugins directory do not exists' do
      before :each do
        expect(File).to receive(:directory?).with('./plugins').and_return(false)
      end

      it 'does nothing' do
        Feedbook::PluginsManager.load_plugins('./plugins')
      end

    end
  end
end
