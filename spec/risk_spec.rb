RSpec.describe Risk do
  let(:stock) { described_class.new(json) }

  context 'when ScreenerAnalysisV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    describe '#bad_news_factor' do
      it { expect(stock.bad_news_factor).to eq(147) }
    end

    describe '#bear_market_factor' do
      it { expect(stock.bear_market_factor).to eq(-2) }
    end

    describe '#beta' do
      it { expect(stock.beta).to eq(134) }
    end

    describe '#volatility' do
      context('1 month') { it { expect(stock.volatility(1)).to eq(20.26) } }
      context('12 months') { it { expect(stock.volatility(12)).to eq(32.56) } }
    end

    describe '#correlation' do
      it { expect(stock.correlation).to eq(0.7) }
    end

    describe '#capitalization' do
      it { expect(stock.capitalization).to eq(319.61) }
    end
  end

  context 'when ScreenerAnalysisV1 is missing' do
    let(:json) { {} }

    describe '#bad_news_factor' do
      it { expect { stock.bad_news_factor }.to_not raise_error }
      it { expect(stock.bad_news_factor).to be_nil }
    end

    describe '#bear_market_factor' do
      it { expect { stock.bear_market_factor }.to_not raise_error }
      it { expect(stock.bear_market_factor).to be_nil }
    end

    describe '#beta' do
      it { expect { stock.beta }.to_not raise_error }
      it { expect(stock.beta).to be_nil }
    end

    describe '#volatility' do
      it { expect { stock.volatility }.to_not raise_error }
      it { expect(stock.volatility).to be_nil }

      context 'when called for unsupported time frame' do
        it { expect { stock.volatility(-1) }.to raise_error(RuntimeError) }
      end

      context 'when called for unsupported time unit' do
        it { expect { stock.volatility(1, :day) }.to raise_error(RuntimeError) }
      end
    end

    describe '#correlation' do
      it { expect { stock.correlation }.to_not raise_error }
      it { expect(stock.correlation).to be_nil }
    end

    describe '#capitalization' do
      it { expect { stock.capitalization }.to_not raise_error }
      it { expect(stock.capitalization).to be_nil }
    end
  end
end
