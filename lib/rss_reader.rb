# liefert die Eintraege des uebergebenen Feeds

module RssReader

  require 'feed-normalizer'
  require 'open-uri'

  def parse(url)
    feed = FeedNormalizer::FeedNormalizer.parse open(url)
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