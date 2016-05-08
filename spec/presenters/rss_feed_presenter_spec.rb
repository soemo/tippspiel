describe RssFeedPresenter do

  subject { RssFeedPresenter.new }
  let(:result) {}

  describe '#rss_title' do

    it 'returns the rss_title' do
      expect(RssFeed::GetTopXEntriesAndTitle).to receive(:call).
          with(rss_feed_url: RSS_FEED_URL, entry_size: 5).
          and_return(double('struct', title: 'ttt', entries: []))

      expect(subject.rss_title).to eq('ttt')
    end
  end

  describe '#rss_entries' do

    it 'returns the rss_entries' do
      expect(RssFeed::GetTopXEntriesAndTitle).to receive(:call).
          with(rss_feed_url: RSS_FEED_URL, entry_size: 5).
          and_return(double('struct', title: 'ttt', entries: []))

      expect(subject.rss_entries).to eq([])
    end
  end
end