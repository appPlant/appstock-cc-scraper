RSpec.describe IntraDayPartial do
  let(:stock) { described_class.new(json) }

  before { Timecop.freeze(Time.utc(2016, 4, 18)) }

  context 'when PriceV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    describe '#available?' do
      it { expect(stock.available?).to be_truthy }
    end

    describe '#price' do
      it { expect(stock.price).to eq(97.653) }
    end

    describe '#high' do
      it { expect(stock.high).to eq(97.91) }
    end

    describe '#low' do
      it { expect(stock.low).to eq(96.021) }
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

    describe '#age_in_days' do
      it { expect(stock.age_in_days).to eq(0) }
    end
  end

  context 'when PriceV1 is missing' do
    let(:json) { {} }

    describe '#available?' do
      it { expect(stock.available?).to be_falsy }
    end

    describe '#price' do
      it { expect { stock.price }.to_not raise_error }
      it { expect(stock.price).to be_nil }
    end

    describe '#high' do
      it { expect { stock.high }.to_not raise_error }
      it { expect(stock.high).to be_nil }
    end

    describe '#low' do
      it { expect { stock.low }.to_not raise_error }
      it { expect(stock.low).to be_nil }
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

    describe '#age_in_days' do
      it { expect { stock.age_in_days }.to_not raise_error }
      it { expect(stock.age_in_days).to be_nil }
    end
  end
end
