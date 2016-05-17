RSpec.describe RecommendationPartial do
  let(:stock) { described_class.new(json) }

  context 'when RecommendationV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    describe '#available?' do
      it { expect(stock.available?).to be_truthy }
    end

    describe '#count' do
      it { expect(stock.count).to eq(38) }
    end

    describe '#upgrades' do
      it { expect(stock.upgrades).to eq(0) }
    end

    describe '#downgrades' do
      it { expect(stock.downgrades).to eq(0) }
    end

    describe '#changes?' do
      it { expect(stock.changes?).to be_falsy }
    end

    describe '#consensus' do
      it { expect(stock.consensus).to eq(4) }
    end

    describe '#target_price' do
      it { expect(stock.target_price).to eq(135.0) }
    end

    describe '#currency' do
      it { expect(stock.currency).to eq('USD') }
    end

    describe '#expected_performance' do
      it { expect(stock.expected_performance).to eq(22.23) }
    end

    describe '#recent' do
      it { expect(stock.recent).to eq(buy: 33, overweight: 3, hold: 2, underweight: 0, sell: 0) }
    end

    describe '#last_quarter' do
      it { expect(stock.last_quarter).to eq(buy: 41, overweight: 4, hold: 4, underweight: 0, sell: 0) }
    end

    describe '#updated_at' do
      it { expect(stock.updated_at).to eq('2016-04-17T22:00:00+0000') }
    end
  end

  context 'when RecommendationV1 is missing' do
    let(:json) { {} }

    describe '#available?' do
      it { expect(stock.available?).to be_falsy }
    end

    describe '#count' do
      it { expect { stock.count }.to_not raise_error }
      it { expect(stock.count).to be_nil }
    end

    describe '#upgrades' do
      it { expect { stock.upgrades }.to_not raise_error }
      it { expect(stock.upgrades).to be_nil }
    end

    describe '#downgrades' do
      it { expect { stock.downgrades }.to_not raise_error }
      it { expect(stock.downgrades).to be_nil }
    end

    describe '#changes?' do
      it { expect { stock.changes? }.to_not raise_error }
      it { expect(stock.changes?).to be_falsy }
    end

    describe '#consensus' do
      it { expect { stock.consensus }.to_not raise_error }
      it { expect(stock.consensus).to be_nil }
    end

    describe '#target_price' do
      it { expect { stock.target_price }.to_not raise_error }
      it { expect(stock.target_price).to be_nil }
    end

    describe '#currency' do
      it { expect { stock.currency }.to_not raise_error }
      it { expect(stock.currency).to be_nil }
    end

    describe '#expected_performance' do
      it { expect { stock.expected_performance }.to_not raise_error }
      it { expect(stock.expected_performance).to be_nil }
    end

    describe '#recent' do
      it { expect { stock.recent }.to_not raise_error }
      it { expect(stock.recent).to be_nil }
    end

    describe '#last_quarter' do
      it { expect { stock.last_quarter }.to_not raise_error }
      it { expect(stock.last_quarter).to be_nil }
    end

    describe '#updated_at' do
      it { expect { stock.updated_at }.to_not raise_error }
      it { expect(stock.updated_at).to be_nil }
    end
  end

  context 'when RecommendationV1 is incomplete' do
    let(:json) { { RecommendationV1: { UP: 1 } } }

    describe '#recent' do
      it { expect(stock.recent).to be_nil }
    end

    describe '#last_quarter' do
      it { expect(stock.last_quarter).to be_nil }
    end
  end
end
