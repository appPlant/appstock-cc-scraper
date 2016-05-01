RSpec.describe Serializer do
  let(:stock) { Stock.new(json) }
  let(:serializer) { described_class.new }
  subject { serializer.serialize(stock) }

  context 'when stock has content' do
    let(:raw) { IO.read('spec/fixtures/facebook.json') }
    let(:json) { JSON.parse(raw, symbolize_names: true)[0] }

    describe 'serialized stock' do
      it { is_expected.to be_a(String) }
      it { expect(JSON.parse(subject)).to_not be_empty }
    end
  end

  context 'when stock has no content' do
    let(:json) { {} }

    describe 'serialized stock' do
      it { expect(JSON.parse(subject)).to be_empty }
    end
  end
end
