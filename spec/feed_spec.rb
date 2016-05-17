RSpec.describe Feed do
  let(:feed) { FactSetFeed.new }

  context 'when stock is empty' do
    let(:stock) { Stock.new({}) }
    subject { feed.generate(stock) }
    describe('generated hash') { it { is_expected.to be_nil } }
  end

  context 'when stock is incomplete' do
    let(:stock) { Stock.new(RecommendationV1: {}) }
    subject { feed.generate(stock) }
    describe('generated hash') { it { is_expected.to be_nil } }
  end

  context 'when partial is incomplete' do
    let(:stock) { Stock.new(RecommendationV1: { UP: 1, DOWN: nil }) }
    subject { feed.generate(stock) }

    describe('generated hash') do
      it { is_expected.to_not be_nil }

      it('should include only non-nil kpis') do
        expect(subject[:kpis].keys).to eq([:upgrades])
      end
    end
  end
end
