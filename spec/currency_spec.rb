RSpec.describe Currency do
  subject { Currency[country] }

  describe 'currency' do
    context 'when country is US' do
      let(:country) { 'US' }
      it { is_expected.to eq('USD') }
    end

    context 'when country is DE' do
      let(:country) { 'DE' }
      it { is_expected.to eq('EUR') }
    end

    context 'when country is unknown' do
      let(:country) { nil }
      it { is_expected.to be_nil }
    end
  end
end
