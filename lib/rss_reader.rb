# -*- encoding : utf-8 -*-
# liefert die Eintraege des uebergebenen Feeds

module RssReader

  require 'feed-normalizer'
  require 'open-uri'
  require 'timeout'

  # den Feed holen und in eine Datei abspeichern,
  # nach 1h erst erneut holen
  def parse(url)
    feed = nil

    begin
      file = File.join(File.expand_path(Rails.root), "tmp", "rss_feed_cache.xml")
      if (File.exists?(file) && File.mtime(file) < 1.hour.ago)
        File.delete(file)
      end

      unless File.exists?(file)
        feed_xml_data = open(url)
        feed = FeedNormalizer::FeedNormalizer.parse feed_xml_data if feed_xml_data.present?
        if feed.present?
          feed = feed.to_json
          File.open(file, 'w+') do |f|
            f.write feed
          end
        end
      end

      feed =  JSON.parse(File.read(file)) if File.exists?(file)
    rescue Exception => e
      puts "Error by grab RSS-Feed : #{e.to_s}"
    end

    feed
  end

  def get_top_x_entries_and_title(url, size=5)
    title = ""
    entries = []
    feed = parse(url)
    if feed.present?
      title = feed["title"]
      entries = feed["items"][0...size]
    end

    [title, entries]
  end

end
