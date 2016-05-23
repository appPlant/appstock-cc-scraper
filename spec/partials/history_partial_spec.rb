RSpec.describe HistoryPartial do
  let(:stock) { described_class.new(json, 'resolution=1D') }

  context 'when HistoryV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    describe '#available?' do
      it { expect(stock.available?).to be_truthy }
    end

    describe '#count' do
      it { expect(stock.count).to eq(31) }
    end

    it('should wrap partials of class PeriodPartial') do
      expect(stock.first.class).to be(PeriodPartial)
    end

    describe '#period' do
      context 'when resolution is daily' do
        it { expect(stock.period).to eq('1D') }
      end
    end

    describe '#currency' do
      it { expect(stock.currency).to eq('EUR') }
    end
  end

  context 'when HistoryV1 is missing' do
    let(:json) { {} }

    describe '#available?' do
      it { expect(stock.available?).to be_falsy }
    end

    describe '#count' do
      it { expect(stock.count).to eq(0) }
    end

    describe '#currency' do
      it { expect { stock.currency }.to_not raise_error }
      it { expect(stock.currency).to be_nil }
    end
  end
end
