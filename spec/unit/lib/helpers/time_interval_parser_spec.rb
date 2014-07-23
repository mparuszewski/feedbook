require 'spec_helper'

describe Feedbook::Helpers::TimeIntervalParser do

  describe '#parse' do

    context 'with proper input parameter' do
      it { expect(Feedbook::Helpers::TimeIntervalParser.parse('1s')).to  eq(1) }
      it { expect(Feedbook::Helpers::TimeIntervalParser.parse('40s')).to eq(40) }
      it { expect(Feedbook::Helpers::TimeIntervalParser.parse('1m')).to  eq(60) }
      it { expect(Feedbook::Helpers::TimeIntervalParser.parse('30m')).to eq(1800) }
      it { expect(Feedbook::Helpers::TimeIntervalParser.parse('1h')).to  eq(3600) }
      it { expect(Feedbook::Helpers::TimeIntervalParser.parse('24h')).to eq(86400) }
      it { expect(Feedbook::Helpers::TimeIntervalParser.parse('1d')).to  eq(86400) }
      it { expect(Feedbook::Helpers::TimeIntervalParser.parse('10d')).to eq(864000) }
    end

    context 'with invalid input parameter' do
      it { expect { Feedbook::Helpers::TimeIntervalParser.parse(nil)  }.to  raise_error(Feedbook::Errors::InvalidIntervalFormatError) }
      it { expect { Feedbook::Helpers::TimeIntervalParser.parse('')   }.to   raise_error(Feedbook::Errors::InvalidIntervalFormatError) }
      it { expect { Feedbook::Helpers::TimeIntervalParser.parse('xx') }.to raise_error(Feedbook::Errors::InvalidIntervalFormatError) }
    end

  end

end
