class RssFeedCell < Cell::Rails
  include RssReader

  cache :show, :expires_in => 15.minutes

  def show(args)
    Rails.logger.info("test sm in RssFeedCell Start") # FIXME soeren 29.04.14 wieder raus
    item_count = args[:item_count]
    @rss_title, @rss_entries = get_top_x_entries_and_title(RSS_FEED_URL, item_count)
    Rails.logger.info("test sm in RssFeedCell End") # FIXME soeren 29.04.14 wieder raus
    render
  end

end
