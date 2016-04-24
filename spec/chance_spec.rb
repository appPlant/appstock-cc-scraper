RSpec.describe Chance do
  let(:stock) { described_class.new(json) }

  context 'when ScreenerAnalysisV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    describe '#available?' do
      it { expect(stock.available?).to be_truthy }
    end

    describe '#dividend' do
      it { expect(stock.dividend).to eq(0) }
    end

    describe '#earnings_revision' do
      it { expect(stock.earnings_revision).to eq(-14) }
    end

    describe '#earnings_trend' do
      it { expect(stock.earnings_trend).to eq(-1) }
    end

    describe '#long_term_potential' do
      it { expect(stock.long_term_potential).to eq(31.89) }
    end

    describe '#long_term_per' do
      it { expect(stock.long_term_per).to eq(27.04) }
    end

    describe '#medium_term_technical_trend' do
      it { expect(stock.medium_term_technical_trend).to eq(1) }
    end

    describe '#analysts' do
      it { expect(stock.analysts).to eq(46) }
    end

    describe '#relative_performance' do
      it { expect(stock.relative_performance).to eq(-1.75) }
    end

    describe '#technical_reverse_price' do
      it { expect(stock.technical_reverse_price).to eq(112.02) }
    end

    describe '#currency' do
      it { expect(stock.currency).to eq('USD') }
    end

    describe '#rating' do
      it { expect(stock.rating).to eq(1) }
    end
  end

  context 'when ScreenerAnalysisV1 is missing' do
    let(:json) { {} }

    describe '#available?' do
      it { expect(stock.available?).to be_falsy }
    end

    describe '#dividend' do
      it { expect { stock.dividend }.to_not raise_error }
      it { expect(stock.dividend).to be_nil }
    end

    describe '#earnings_revision' do
      it { expect { stock.earnings_revision }.to_not raise_error }
      it { expect(stock.earnings_revision).to be_nil }
    end

    describe '#earnings_trend' do
      it { expect { stock.earnings_trend }.to_not raise_error }
      it { expect(stock.earnings_trend).to be_nil }
    end

    describe '#long_term_potential' do
      it { expect { stock.long_term_potential }.to_not raise_error }
      it { expect(stock.long_term_potential).to be_nil }
    end

    describe '#long_term_per' do
      it { expect { stock.long_term_per }.to_not raise_error }
      it { expect(stock.long_term_per).to be_nil }
    end

    describe '#medium_term_technical_trend' do
      it { expect { stock.medium_term_technical_trend }.to_not raise_error }
      it { expect(stock.medium_term_technical_trend).to be_nil }
    end

    describe '#analysts' do
      it { expect { stock.analysts }.to_not raise_error }
      it { expect(stock.analysts).to be_nil }
    end

    describe '#relative_performance' do
      it { expect { stock.relative_performance }.to_not raise_error }
      it { expect(stock.relative_performance).to be_nil }
    end

    describe '#technical_reverse_price' do
      it { expect { stock.technical_reverse_price }.to_not raise_error }
      it { expect(stock.technical_reverse_price).to be_nil }
    end

    describe '#currency' do
      it { expect { stock.currency }.to_not raise_error }
      it { expect(stock.currency).to be_nil }
    end

    describe '#rating' do
      it { expect { stock.rating }.to_not raise_error }
      it { expect(stock.rating).to be_nil }
    end
  end
end
