require 'oj'

RSpec.describe Screener do
  let(:stock) { described_class.new(json) }
  subject { stock }

  context 'when ScreenerV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { Oj.load(raw, symbol_keys: true)[0] }

    describe '#per' do
      it { expect(stock.per).to eq(22.57) }
    end

    describe '#risk' do
      it { expect(stock.risk).to eq(0) }
    end

    describe '#interest' do
      it { expect(stock.interest).to eq(3) }
    end

    describe '#updated_at' do
      it { expect(stock.updated_at).to eq('2016-04-14T22:00:00+0000') }
    end
  end

  context 'when ScreenerV1 is missing' do
    let(:json) { {} }

    describe '#per' do
      it { expect { stock.per }.to_not raise_error }
      it { expect(stock.per).to be_nil }
    end

    describe '#risk' do
      it { expect { stock.risk }.to_not raise_error }
      it { expect(stock.risk).to be_nil }
    end

    describe '#interest' do
      it { expect { stock.interest }.to_not raise_error }
      it { expect(stock.interest).to be_nil }
    end

    describe '#updated_at' do
      it { expect { stock.updated_at }.to_not raise_error }
      it { expect(stock.updated_at).to be_nil }
    end
  end
end
