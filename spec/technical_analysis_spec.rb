RSpec.describe TechnicalAnalysis do
  let(:stock) { described_class.new(json) }
  subject { stock }

  context 'when TechnicalAnalysisV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    describe '#macd' do
      it { expect(stock.macd).to eq(1) }
    end

    describe '#momentum' do
      it { expect(stock.momentum).to eq(1) }
      context('20 days') { it { expect(stock.momentum(20)).to eq(1) } }
      context('50 days') { it { expect(stock.momentum(50)).to eq(1) } }
      context('250 days') { it { expect(stock.momentum(250)).to eq(1) } }
      context('trend') { it { expect(stock.momentum(:trend)).to eq(3) } }
    end

    describe '#moving_average' do
      it { expect(stock.moving_average).to eq(1) }
      context('5 days') { it { expect(stock.moving_average(5)).to eq(1) } }
      context('20 days') { it { expect(stock.moving_average(20)).to eq(1) } }
      context('200 days') { it { expect(stock.moving_average(200)).to eq(1) } }
      context('trend') { it { expect(stock.moving_average(:trend)).to eq(3) } }
    end

    describe '#rsi' do
      it { expect(stock.rsi).to eq(1) }
      context('5 days') { it { expect(stock.rsi(5)).to eq(1) } }
      context('20 days') { it { expect(stock.rsi(20)).to eq(0) } }
      context('250 days') { it { expect(stock.rsi(250)).to eq(0) } }
      context('trend') { it { expect(stock.rsi(:trend)).to eq(1) } }
    end
  end

  context 'when TechnicalAnalysisV1 is missing' do
    let(:json) { {} }

    describe '#macd' do
      it { expect { stock.macd }.to_not raise_error }
      it { expect(stock.macd).to be_nil }
    end

    describe '#momentum' do
      it { expect { stock.momentum }.to_not raise_error }
      it { expect(stock.momentum).to be_nil }

      context 'when called for unsupported time frame' do
        it { expect { stock.momentum(-1) }.to raise_error(RuntimeError) }
      end
    end

    describe '#moving_average' do
      it { expect { stock.moving_average }.to_not raise_error }
      it { expect(stock.moving_average).to be_nil }

      context 'when called for unsupported time frame' do
        it { expect { stock.moving_average(-1) }.to raise_error(RuntimeError) }
      end
    end

    describe '#rsi' do
      it { expect { stock.rsi }.to_not raise_error }
      it { expect(stock.rsi).to be_nil }

      context 'when called for unsupported time frame' do
        it { expect { stock.rsi(-1) }.to raise_error(RuntimeError) }
      end
    end
  end
end
