RSpec.describe ChancePartial do
  let(:stock) { ChancePartial.new(json) }

  before { Timecop.freeze(Time.utc(2016, 4, 18)) }

  context 'when ScreenerAnalysisV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    describe '#available?' do
      it { expect(stock.available?).to be_truthy }
    end

    describe '#dividend' do
      it { expect(stock.dividend).to eq(0) }
    end

    describe '#earnings' do
      let(:earnings) { stock.earnings }
      describe(:revision) { it { expect(earnings[:revision]).to eq(-14) } }
      describe(:trend) { it { expect(earnings[:trend]).to eq(-1) } }
      describe(:growth) { it { expect(earnings[:growth]).to eq(31.89) } }
    end

    describe '#per' do
      it { expect(stock.per).to eq(27.04) }
    end

    describe '#trend' do
      it { expect(stock.trend).to eq(1) }
    end

    describe '#analysts' do
      it { expect(stock.analysts).to eq(46) }
    end

    describe '#outperformanceerformance' do
      it { expect(stock.outperformance).to eq(-1.75) }
    end

    describe '#reverse_price' do
      it { expect(stock.reverse_price).to eq(112.02) }
    end

    describe '#price' do
      it { expect(stock.price).to eq(112.29) }
    end

    describe '#currency' do
      it { expect(stock.currency).to eq('USD') }
    end

    describe '#rating' do
      it { expect(stock.rating).to eq(1) }
    end

    describe '#age_in_days' do
      it { expect(stock.age_in_days).to eq(0) }
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

    describe '#earnings' do
      it { expect { stock.earnings }.to_not raise_error }
      it { expect(stock.earnings).to be_nil }
    end

    describe '#per' do
      it { expect { stock.per }.to_not raise_error }
      it { expect(stock.per).to be_nil }
    end

    describe '#trend' do
      it { expect { stock.trend }.to_not raise_error }
      it { expect(stock.trend).to be_nil }
    end

    describe '#analysts' do
      it { expect { stock.analysts }.to_not raise_error }
      it { expect(stock.analysts).to be_nil }
    end

    describe '#outperformance' do
      it { expect { stock.outperformance }.to_not raise_error }
      it { expect(stock.outperformance).to be_nil }
    end

    describe '#reverse_price' do
      it { expect { stock.reverse_price }.to_not raise_error }
      it { expect(stock.reverse_price).to be_nil }
    end

    describe '#price' do
      it { expect { stock.price }.to_not raise_error }
      it { expect(stock.price).to be_nil }
    end

    describe '#currency' do
      it { expect { stock.currency }.to_not raise_error }
      it { expect(stock.currency).to be_nil }
    end

    describe '#rating' do
      it { expect { stock.rating }.to_not raise_error }
      it { expect(stock.rating).to be_nil }
    end

    describe '#age_in_days' do
      it { expect { stock.age_in_days }.to_not raise_error }
      it { expect(stock.age_in_days).to be_nil }
    end
  end

  context 'when ScreenerAnalysisV1 is incomplete' do
    let(:json) { { ScreenerAnalysisV1: { CHANCE: { DIVIDEND: 1 } } } }

    describe '#earnings' do
      it { expect(stock.earnings).to be_nil }
    end
  end
end
