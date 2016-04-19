require 'oj'

RSpec.describe Performance do
  let(:stock) { described_class.new(json) }
  subject { stock }

  context 'when PerformanceV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { Oj.load(raw, symbol_keys: true)[0] }

    describe '#w_1' do
      it { expect(stock.w_1).to eq(0.14) }
    end

    describe '#w_4' do
      it { expect(stock.w_4).to eq(-2.45) }
    end

    describe '#w_52' do
      it { expect(stock.w_52).to eq(25.51) }
    end

    describe '#y_c' do
      it { expect(stock.y_c).to eq(-0.75) }
    end

    describe '#y_3' do
      it { expect(stock.y_3).to eq(377.76) }
    end

    describe '#w_52_high' do
      it { expect(stock.w_52_high).to eq(107.86) }
    end

    describe '#w_52_low' do
      it { expect(stock.w_52_low).to eq(61.86) }
    end

    describe '#w_52_high_at' do
      it { expect(stock.w_52_high_at).to eq('2016-02-01T23:00:00+0000') }
    end

    describe '#w_52_low' do
      it { expect(stock.w_52_low_at).to eq('2015-08-23T22:00:00+0000') }
    end
  end

  context 'when PerformanceV1 is missing' do
    let(:json) { {} }

    describe '#w_1' do
      it { expect { stock.w_1 }.to_not raise_error }
      it { expect(stock.w_1).to be_nil }
    end

    describe '#w_4' do
      it { expect { stock.w_4 }.to_not raise_error }
      it { expect(stock.w_4).to be_nil }
    end

    describe '#w_52' do
      it { expect { stock.w_52 }.to_not raise_error }
      it { expect(stock.w_52).to be_nil }
    end

    describe '#y_c' do
      it { expect { stock.y_c }.to_not raise_error }
      it { expect(stock.y_c).to be_nil }
    end

    describe '#y_3' do
      it { expect { stock.y_3 }.to_not raise_error }
      it { expect(stock.y_3).to be_nil }
    end

    describe '#w_52_high' do
      it { expect { stock.w_52_high }.to_not raise_error }
      it { expect(stock.w_52_high).to be_nil }
    end

    describe '#w_52_low' do
      it { expect { stock.w_52_low }.to_not raise_error }
      it { expect(stock.w_52_low).to be_nil }
    end

    describe '#w_52_high_at' do
      it { expect { stock.w_52_high_at }.to_not raise_error }
      it { expect(stock.w_52_high_at).to be_nil }
    end

    describe '#w_52_low_at' do
      it { expect { stock.w_52_low_at }.to_not raise_error }
      it { expect(stock.w_52_low_at).to be_nil }
    end
  end
end
