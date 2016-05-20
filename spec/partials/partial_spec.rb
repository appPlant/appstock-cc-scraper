RSpec.describe Partial do
  describe '#prune' do
    let(:partial) { described_class.new data }

    context 'when not available' do
      let(:data) { nil }
      subject { partial.send :prune, [1] }
      it { is_expected.to be_nil }
    end

    context 'when available' do
      let(:data) { { key: :value } }

      describe 'pruned array with values' do
        subject { partial.send :prune, [1] }
        it { is_expected.to be_a(Array) }
        it { is_expected.to_not be_empty }
      end

      describe 'pruned array with mixed values and nil' do
        subject { partial.send(:prune, [1, nil, 2]) }
        it { is_expected.to be_a(Array) }
        it('should not prune array') { is_expected.to eq([1, nil, 2]) }
      end

      describe 'pruned array with only nil values' do
        subject { partial.send :prune, [nil] }
        it { is_expected.to be_nil }
      end

      describe 'pruned array without values' do
        subject { partial.send :prune, [] }
        it { is_expected.to be_nil }
      end
    end
  end

  describe '#diff_in_days' do
    let(:partial) { described_class.new data }

    context 'when not available' do
      let(:data) { nil }
      subject { partial.send :diff_in_days, 1 }
      it { is_expected.to be_nil }
    end

    context 'when available' do
      let(:data) { { key: :value } }
      subject { partial.send :diff_in_days, date }

      context 'when passing nil' do
        let(:date) { nil }
        it { is_expected.to be_nil }
      end

      context 'when passing yesterday as a date' do
        let(:date) { Date.today - 1 }
        it { is_expected.to be(1) }
      end

      context 'when passing yesterday as a number' do
        let(:date) { (Date.today - 1).to_time.to_i }
        it { is_expected.to be(1) }
      end

      context 'when passing yesterday as a string' do
        let(:date) { (Date.today - 1).to_s }
        it { is_expected.to be(1) }
      end
    end
  end
end
