require './lib/guide_data'

describe GuideData do
  let(:guide_urls) { GuideData.define_guide_search_terms }

  context 'given an existing guide' do
    it 'returns the url' do
      expect(guide_urls[:announcement]).to eql('guides/creating-an-announcement/')
    end
  end
  context 'given a non-existent guide' do
    it 'returns nil' do
      expect(guide_urls[:elephant]).to be_nil
    end
  end
end
