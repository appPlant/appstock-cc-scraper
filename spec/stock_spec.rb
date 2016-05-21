RSpec.describe Stock do
  let(:raw)   { IO.read('spec/fixtures/facebook.json') }
  let(:json)  { JSON.parse(raw, symbolize_names: true)[0] }
  let(:stock) { described_class.new(json) }
  subject { stock }

  it { is_expected.to respond_to(:data, :to_json) }

  describe '#data' do
    it { expect(stock.data).to_not be_a(Array) }
  end

  describe '#screener' do
    it { expect(stock.screener).to be_a(ScreenerPartial) }
  end

  describe '#recommendations' do
    it { expect(stock.recommendations).to be_a(RecommendationPartial) }
  end

  describe '#performance' do
    it { expect(stock.performance).to be_a(PerformancePartial) }
  end

  describe '#intra' do
    it { expect(stock.intra).to be_a(IntraDayPartial) }
  end

  describe '#technical_analysis' do
    it { expect(stock.technical_analysis).to be_a(TechnicalAnalysisPartial) }
  end

  describe '#trading_central' do
    it { expect(stock.trading_central).to be_a(TradingCentralPartial) }
  end

  describe '#risk' do
    it { expect(stock.risk).to be_a(RiskPartial) }
  end

  describe '#chance' do
    it { expect(stock.chance).to be_a(ChancePartial) }
  end

  describe '#events' do
    it { expect(stock.events).to be_a(EventsPartial) }
    it('should contain of event partials') do
      expect(stock.events.partial_class).to be(EventPartial)
    end
  end

  describe '#available?' do
    context 'when ISIN is present' do
      it { expect(stock.available?).to be_truthy }
    end

    context 'when ISIN is missing' do
      before { allow(stock).to receive(:isin).and_return(nil) }
      it { expect(stock.available?).to be_falsy }
    end

    context 'when data is missing' do
      subject { described_class.new(nil).available? }
      it { is_expected.to be_falsy }
    end
  end

  describe '#inspect' do
    it { expect(stock.inspect).to match(stock.name) }
  end
end
