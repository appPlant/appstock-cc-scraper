require 'oj'

RSpec.describe Stock do
  let(:raw)   { IO.read('spec/fixtures/facebook.json') }
  let(:json)  { Oj.load(raw, symbol_keys: true)[0] }
  let(:stock) { described_class.new(json) }
  subject { stock }

  it { is_expected.to respond_to(:data, :to_json) }

  describe '#data' do
    it { expect(stock.data).to_not be_a(Array) }
  end

  describe '#screener' do
    it { expect(stock.screener).to be_a(Screener) }
  end

  describe '#recommendations' do
    it { expect(stock.recommendations).to be_a(Recommendations) }
  end

  describe '#performance' do
    it { expect(stock.performance).to be_a(Performance) }
  end

  describe '#intraday' do
    it { expect(stock.intraday).to be_a(IntraDay) }
  end

  describe '#inspect' do
    it { expect(stock.inspect).to match(stock.name) }
  end
end