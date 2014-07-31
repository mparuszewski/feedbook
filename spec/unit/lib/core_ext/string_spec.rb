require 'spec_helper'

describe String do
  describe '#camelize' do
    it { expect(''.camelize).to eq('') }
    it { expect('test'.camelize).to eq('Test') }
    it { expect('test_tester_test'.camelize).to eq('TestTesterTest') }
    it { expect('TeStEr_TTEESSTT'.camelize).to eq('TesterTteesstt') }
  end
end
