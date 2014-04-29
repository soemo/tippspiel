class RssFeedCell < Cell::Rails
  include RssReader

  cache :show, :expires_in => 15.minutes

  def show(args)
    item_count = args[:item_count]
    @rss_title, @rss_entries = get_top_x_entries_and_title(RSS_FEED_URL, item_count)
    render
  end

end
