RSpec.describe Performance do
  let(:perf) { described_class.new(json) }

  context 'when PerformanceV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    describe '#available?' do
      it { expect(perf.available?).to be_truthy }
    end

    describe '#of' do
      context('1 week') { it { expect(perf.of(1, :week)).to eq(0.14) } }
      context('4 weeks') { it { expect(perf.of(4, :weeks)).to eq(-2.45) } }
      context('52 weeks') { it { expect(perf.of(52, :weeks)).to eq(25.51) } }
      context('current year') { it { expect(perf.of(:current, :year)).to eq(-0.75) } }
      context('3 years') { it { expect(perf.of(3, :years)).to eq(377.76) } }
    end

    describe '#high' do
      it { expect(perf.high).to eq(107.86) }
    end

    describe '#low' do
      it { expect(perf.low).to eq(61.86) }
    end

    describe '#high_at' do
      it { expect(perf.high_at).to eq('2016-02-01T23:00:00+0000') }
    end

    describe '#low' do
      it { expect(perf.low_at).to eq('2015-08-23T22:00:00+0000') }
    end
  end

  context 'when PerformanceV1 is missing' do
    let(:json) { {} }

    describe '#available?' do
      it { expect(perf.available?).to be_falsy }
    end

    describe '#of' do
      it { expect { perf.of(1, :week) }.to_not raise_error }
      it { expect(perf.of(1, :week)).to be_nil }

      context 'when called for unsupported time frame' do
        it { expect { perf.of(2, :weeks) }.to raise_error(RuntimeError) }
        it { expect { perf.of(2, :years) }.to raise_error(RuntimeError) }
      end

      context 'when called for unsupported time unit' do
        it { expect { perf.of(3, :days) }.to raise_error(RuntimeError) }
      end
    end

    describe '#high' do
      it { expect { perf.high }.to_not raise_error }
      it { expect(perf.high).to be_nil }
    end

    describe '#low' do
      it { expect { perf.low }.to_not raise_error }
      it { expect(perf.low).to be_nil }
    end

    describe '#high_at' do
      it { expect { perf.high_at }.to_not raise_error }
      it { expect(perf.high_at).to be_nil }
    end

    describe '#low_at' do
      it { expect { perf.low_at }.to_not raise_error }
      it { expect(perf.low_at).to be_nil }
    end
  end
end
