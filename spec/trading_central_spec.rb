RSpec.describe TradingCentral do
  let(:stock) { described_class.new(json) }

  context 'when TradingCentralV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    describe '#pivot' do
      it { expect(stock.pivot).to eq(103.9) }
    end

    describe '#support_levels' do
      it { expect(stock.support_levels).to eq([103.9, 96.7, 89.3]) }
    end

    describe '#resistance_levels' do
      it { expect(stock.resistance_levels).to eq([117.6, 125, 131]) }
    end

    describe '#short_term_potential' do
      let(:potential) { stock.short_term_potential }
      describe(':delta') { it { expect(potential[:delta]).to eq(0) } }
      describe(':opinion') { it { expect(potential[:opinion]).to eq(2) } }
    end

    describe '#medium_term_potential' do
      let(:potential) { stock.medium_term_potential }
      describe(':delta') { it { expect(potential[:delta]).to eq(0) } }
      describe(':opinion') { it { expect(potential[:opinion]).to eq(1) } }
    end

    describe '#updated_at' do
      it { expect(stock.updated_at).to eq('2016-04-20T13:23:00+0000') }
    end
  end

  context 'when TradingCentralV1 is missing' do
    let(:json) { {} }

    describe '#pivot' do
      it { expect { stock.pivot }.to_not raise_error }
      it { expect(stock.pivot).to be_nil }
    end

    describe '#support_levels' do
      it { expect { stock.support_levels }.to_not raise_error }
      it { expect(stock.support_levels).to eq([nil, nil, nil]) }
    end

    describe '#resistance_levels' do
      it { expect { stock.resistance_levels }.to_not raise_error }
      it { expect(stock.resistance_levels).to eq([nil, nil, nil]) }
    end

    describe '#short_term_potential' do
      it { expect { stock.short_term_potential }.to_not raise_error }
      it { expect(stock.short_term_potential).to eq(delta: nil, opinion: nil) }
    end

    describe '#medium_term_potential' do
      it { expect { stock.medium_term_potential }.to_not raise_error }
      it { expect(stock.medium_term_potential).to eq(delta: nil, opinion: nil) }
    end

    describe '#updated_at' do
      it { expect { stock.updated_at }.to_not raise_error }
      it { expect(stock.updated_at).to be_nil }
    end
  end
end
