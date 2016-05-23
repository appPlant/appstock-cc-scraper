RSpec.describe Serializer do
  let(:stock) { Stock.new(json, 'resolution=1W') }
  let(:serializer) { described_class.new }
  let(:serialized) { serializer.serialize(stock) }
  subject { serialized.chomp if serialized }

  before { Timecop.freeze(Time.utc(2016, 5, 2, 21, 26, 0)) }

  context 'when stock has content' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    describe 'serialized stock' do
      let(:expected) { IO.read('spec/fixtures/facebook.serialized.json').chomp }
      it('should be equal to expected output') { is_expected.to eq(expected) }
    end
  end

  context 'when stock has no content' do
    let(:json) { {} }

    describe 'serialized stock' do
      it { is_expected.to be_nil }
    end
  end

  context 'when PerformanceV1 is missing' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    before { json.delete :PerformanceV1 }

    describe 'serialized stock' do
      let(:feeds) { JSON.parse(subject)['feeds'] }
      it('should not include performance') do
        expect(feeds.any? { |i| i['source'] == 'performance' }).to be_falsy
      end
    end
  end
end
