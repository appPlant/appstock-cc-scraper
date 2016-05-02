RSpec.describe Serializer do
  let(:stock) { Stock.new(json) }
  let(:serializer) { described_class.new }
  subject { serializer.serialize(stock).chomp }

  before { Timecop.freeze(Time.local(2016, 5, 2, 21, 26, 0)) }

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
      it { expect(JSON.parse(subject)).to be_empty }
    end
  end

  context 'when PerformanceV1 is missing' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    before { json.delete :PerformanceV1 }

    describe 'serialized stock' do
      let(:analyses) { JSON.parse(subject)['analyses'] }
      it('should not include performance') { expect(analyses.count).to eq(4) }
    end
  end
end
