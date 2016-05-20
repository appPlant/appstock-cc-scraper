RSpec.describe ScreenerPartial do
  let(:stock) { described_class.new(json) }

  before { Timecop.freeze(Time.utc(2016, 4, 18)) }

  context 'when ScreenerV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    describe '#available?' do
      it { expect(stock.available?).to be_truthy }
    end

    describe '#per' do
      it { expect(stock.per).to eq(22.57) }
    end

    describe '#risk' do
      it { expect(stock.risk).to eq(0) }
    end

    describe '#interest' do
      it { expect(stock.interest).to eq(3) }
    end

    describe '#age_in_days' do
      it { expect(stock.age_in_days).to eq(4) }
    end
  end

  context 'when ScreenerV1 is missing' do
    let(:json) { {} }

    describe '#available?' do
      it { expect(stock.available?).to be_falsy }
    end

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

    describe '#age_in_days' do
      it { expect { stock.age_in_days }.to_not raise_error }
      it { expect(stock.age_in_days).to be_nil }
    end
  end
end
