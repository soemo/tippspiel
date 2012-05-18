# liefert die Eintraege des uebergebenen Feeds

module RssReader

  require 'feed-normalizer'
  require 'open-uri'
  require 'timeout'

  def parse(url)
    ## FIXME soeren 16.05.12 caching
    feed = nil
    begin
    status = Timeout::timeout(5) {
      feed = FeedNormalizer::FeedNormalizer.parse open(url)
    }
    rescue Timeout::Error => e
      puts e.to_s
    end

    feed
  end

  def get_top_x_entries_and_title(url, size=5)
    title = ""
    entries = []
    feed = parse(url)
    if feed.present?
      title = feed.title
      entries = feed.entries[0...size]
    end

    [title, entries]
  end

end