require 'fakefs/spec_helpers'

RSpec.describe Scraper do
  let(:drop_box) { 'tmp/data' }
  let(:scraper) { described_class.new drop_box: drop_box }
  subject { scraper }

  it { is_expected.to respond_to(:run, :drop_box) }

  context 'when initialized with tmp/data' do
    describe '#drop_box' do
      it { expect(scraper.drop_box).to eq(drop_box) }
    end
  end

  context 'Scraper::FIELDS' do
    subject { Scraper::FIELDS }
    it { is_expected.to be_frozen }
    it { is_expected.to_not be_empty }
  end

  describe '#run' do
    include FakeFS::SpecHelpers

    let(:run) { -> { scraper.run ['US30303M1027'] } }

    context 'when consorsbank is offline' do
      before { stub_request(:get, %r{/rest/de/marketdata/stocks}).to_timeout }
      it { expect { run.call }.to_not raise_error }
      it('should return 0') { expect(run.call).to be_zero }
    end

    context 'when request responds with 500' do
      before { stub_request(:get, %r{/rest/de/}).to_return status: 503 }
      it { expect { run.call }.to_not raise_error }
    end

    context 'when responds body has unexpected content type' do
      before { stub_request(:get, %r{/rest/de/}).to_return body: 'busy' }
      it { expect { run.call }.to_not raise_error }
    end

    context 'when response body is valid' do
      let(:content) { IO.read('spec/fixtures/facebook.json') }
      before { stub_request(:get, /id=US30303M1027/).to_return body: content }
      it('should return 1') { expect(run.call).to be(1) }

      describe 'drop_box entries' do
        let(:entries) { Dir.glob "#{scraper.drop_box}/US30303M1027-*.json" }
        before { run.call }
        it { expect(entries.count).to eq(1) }
        it('should be valid JSON files') do
          expect { JSON.parse(File.read(entries.first)) }.to_not raise_error
        end
      end
    end
  end
end
