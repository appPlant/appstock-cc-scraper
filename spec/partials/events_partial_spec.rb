RSpec.describe EventsPartial do
  let(:stock) { described_class.new(json) }

  context 'when EventsV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    describe '#available?' do
      it { expect(stock.available?).to be_truthy }
    end

    describe '#count' do
      it { expect(stock.count).to eq(3) }
    end

    it('should wrap partials of class EventPartial') do
      expect(stock.first.class).to be(EventPartial)
    end
  end

  context 'when EventsV1 is missing' do
    let(:json) { {} }

    describe '#available?' do
      it { expect(stock.available?).to be_falsy }
    end

    describe '#count' do
      it { expect(stock.count).to eq(0) }
    end
  end
end
