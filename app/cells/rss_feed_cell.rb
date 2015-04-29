class RssFeedCell < Cell::Rails

  cache :show, :expires_in => 15.minutes

  def show(args)
    item_count = args[:item_count]
    result = RssFeed::GetTopXEntriesAndTitle.call(rss_feed_url: RSS_FEED_URL,
                                                entry_size: item_count)

    render locals: {rss_title: result.title, rss_entries: result.entries}
  end

end
