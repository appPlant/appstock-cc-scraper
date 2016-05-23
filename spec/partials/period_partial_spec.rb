RSpec.describe PeriodPartial do
  let!(:history) { HistoryPartial.new(json, '') }
  let!(:period) { history.first }

  before { Timecop.freeze(Time.utc(2016, 4, 18)) }

  context 'when HistoryV1 is present' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    describe '#first' do
      it { expect(period.first).to eq(97.049) }
    end

    describe '#last' do
      it { expect(period.last).to eq(97.803) }
    end

    describe '#high' do
      it { expect(period.high).to eq(97.91) }
    end

    describe '#low' do
      it { expect(period.low).to eq(96.021) }
    end

    describe '#age' do
      it { expect(period.age).to eq(0) }
    end
  end
end
