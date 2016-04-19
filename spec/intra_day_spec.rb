require 'oj'

RSpec.describe IntraDay do
  let(:stock) { described_class.new(json) }
  subject { stock }

  context 'when PriceV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { Oj.load(raw, symbol_keys: true)[0] }

    describe '#price' do
      it { expect(stock.price).to eq(97.653) }
    end

    describe '#highest_price' do
      it { expect(stock.highest_price).to eq(97.91) }
    end

    describe '#lowest_price' do
      it { expect(stock.lowest_price).to eq(96.021) }
    end

    describe '#currency' do
      it { expect(stock.currency).to eq('EUR') }
    end

    describe '#realtime?' do
      it { expect(stock.realtime?).to be_truthy }
    end

    describe '#performance' do
      it { expect(stock.performance).to eq(0.46) }
    end

    describe '#volume' do
      it { expect(stock.volume).to eq(12_387) }
    end

    describe '#exchange' do
      it { expect(stock.exchange).to eq('GAT') }
    end

    describe '#updated_at' do
      it { expect(stock.updated_at).to eq('2016-04-18T20:25:49+0000') }
    end
  end

  context 'when PriceV1 is missing' do
    let(:json) { {} }

    describe '#price' do
      it { expect { stock.price }.to_not raise_error }
      it { expect(stock.price).to be_nil }
    end

    describe '#highest_price' do
      it { expect { stock.highest_price }.to_not raise_error }
      it { expect(stock.highest_price).to be_nil }
    end

    describe '#lowest_price' do
      it { expect { stock.lowest_price }.to_not raise_error }
      it { expect(stock.lowest_price).to be_nil }
    end

    describe '#currency' do
      it { expect { stock.currency }.to_not raise_error }
      it { expect(stock.currency).to be_nil }
    end

    describe '#realtime?' do
      it { expect { stock.realtime? }.to_not raise_error }
      it { expect(stock.realtime?).to be_nil }
    end

    describe '#performance' do
      it { expect { stock.performance }.to_not raise_error }
      it { expect(stock.performance).to be_nil }
    end

    describe '#volume' do
      it { expect { stock.volume }.to_not raise_error }
      it { expect(stock.volume).to be_nil }
    end

    describe '#exchange' do
      it { expect { stock.exchange }.to_not raise_error }
      it { expect(stock.exchange).to be_nil }
    end

    describe '#updated_at' do
      it { expect { stock.updated_at }.to_not raise_error }
      it { expect(stock.updated_at).to be_nil }
    end
  end
end
