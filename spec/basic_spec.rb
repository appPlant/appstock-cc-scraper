RSpec.describe Stock do
  let(:stock) { described_class.new(json) }

  context 'when BasicV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    describe '#name' do
      it { expect(stock.name).to eq('FACEBOOK INC.') }
    end

    describe '#wkn' do
      it { expect(stock.wkn).to eq('A1JWVX') }
    end

    describe '#isin' do
      it { expect(stock.isin).to eq('US30303M1027') }
    end

    describe '#symbol' do
      it { expect(stock.symbol).to eq('FB2A') }
    end

    describe '#branch' do
      it { expect(stock.branch).to eq('Internetservice') }
    end

    describe '#sector' do
      it { expect(stock.sector).to eq('Informationstechnologie') }
    end
  end

  context 'when BasicV1 is missing' do
    let(:json) { {} }

    describe '#name' do
      it { expect { stock.name }.to_not raise_error }
      it { expect(stock.name).to be_nil }
    end

    describe '#wkn' do
      it { expect { stock.wkn }.to_not raise_error }
      it { expect(stock.wkn).to be_nil }
    end

    describe '#isin' do
      it { expect { stock.isin }.to_not raise_error }
      it { expect(stock.isin).to be_nil }
    end

    describe '#symbol' do
      it { expect { stock.symbol }.to_not raise_error }
      it { expect(stock.symbol).to be_nil }
    end

    describe '#branch' do
      it { expect { stock.branch }.to_not raise_error }
      it { expect(stock.branch).to be_nil }
    end

    describe '#sector' do
      it { expect { stock.sector }.to_not raise_error }
      it { expect(stock.sector).to be_nil }
    end
  end
end
