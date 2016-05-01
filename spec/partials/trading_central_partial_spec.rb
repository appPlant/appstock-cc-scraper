RSpec.describe TradingCentralPartial do
  let(:stock) { described_class.new(json) }

  context 'when TradingCentralV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    describe '#available?' do
      it { expect(stock.available?).to be_truthy }
    end

    describe '#pivot' do
      it { expect(stock.pivot).to eq(103.9) }
    end

    describe '#supports' do
      it { expect(stock.supports).to eq([103.9, 96.7, 89.3]) }
    end

    describe '#resistors' do
      it { expect(stock.resistors).to eq([117.6, 125, 131]) }
    end

    describe '#short_term' do
      let(:potential) { stock.short_term }
      describe(':delta') { it { expect(potential[:delta]).to eq(0) } }
      describe(':opinion') { it { expect(potential[:opinion]).to eq(2) } }
    end

    describe '#medium_term' do
      let(:potential) { stock.medium_term }
      describe(':delta') { it { expect(potential[:delta]).to eq(0) } }
      describe(':opinion') { it { expect(potential[:opinion]).to eq(1) } }
    end

    describe '#updated_at' do
      it { expect(stock.updated_at).to eq('2016-04-20T13:23:00+0000') }
    end
  end

  context 'when TradingCentralV1 is missing' do
    let(:json) { {} }

    describe '#available?' do
      it { expect(stock.available?).to be_falsy }
    end

    describe '#pivot' do
      it { expect { stock.pivot }.to_not raise_error }
      it { expect(stock.pivot).to be_nil }
    end

    describe '#supports' do
      it { expect { stock.supports }.to_not raise_error }
      it { expect(stock.supports).to eq([nil, nil, nil]) }
    end

    describe '#resistors' do
      it { expect { stock.resistors }.to_not raise_error }
      it { expect(stock.resistors).to eq([nil, nil, nil]) }
    end

    describe '#short_term' do
      it { expect { stock.short_term }.to_not raise_error }
      it { expect(stock.short_term).to eq(delta: nil, opinion: nil) }
    end

    describe '#medium_term' do
      it { expect { stock.medium_term }.to_not raise_error }
      it { expect(stock.medium_term).to eq(delta: nil, opinion: nil) }
    end

    describe '#updated_at' do
      it { expect { stock.updated_at }.to_not raise_error }
      it { expect(stock.updated_at).to be_nil }
    end
  end
end
