class RssFeedPresenter

  def initialize
  end

  def rss_title
    title_and_entries.title
  end

  def rss_entries
    title_and_entries.entries
  end

  private

  def title_and_entries
    @title_and_entries ||= RssFeed::GetTopXEntriesAndTitle.call(rss_feed_url: RSS_FEED_URL,
                                                                entry_size: 5)
  end
end