# -*- encoding : utf-8 -*-
# liefert die Eintraege des uebergebenen Feeds

module RssReader

  require 'feed-normalizer'
  require 'open-uri'
  require 'timeout'

  # den Feed holen und in eine Datei abspeichern,
  # nach 55min erst erneut holen
  def parse(url)
    result = nil
    file = write_rss_feed_cache_xml_file(url)
    result = JSON.parse(File.read(file)) if File.exists?(file)

    result
  end

  # Wird auch im hourly scheduler aufgerufen
  def write_rss_feed_cache_xml_file(url)
    Rails.logger.info('CHECK RSS-FEED-XML-FILE')
    file = File.join(File.expand_path(Rails.root), 'tmp', 'rss_feed_cache.xml')
    begin
      if File.exists?(file) && File.mtime(file) < 55.minutes.ago
        Rails.logger.info('DELETE OLD RSS-FEED-XML-FILE')
        File.delete(file)
      end

      unless File.exists?(file)
        feed_xml_data = open(url)
        if feed_xml_data.present?
          feed = FeedNormalizer::FeedNormalizer.parse(feed_xml_data)
          if feed.present?
            Rails.logger.info('WRITE NEW RSS-FEED-XML-FILE')
            File.open(file, 'w+') do |f|
              f.write feed.to_json
            end
          end
        end
      end
    rescue Exception => e
      Rails.logger.error("Error by grab RSS-Feed : #{e.to_s}")
    end

    file
  end

  def get_top_x_entries_and_title(url, size=5)
    title = ''
    entries = []
    feed = parse(url)
    if feed.present?
      title = feed['title']
      entries = feed['items'][0...size]
    end

    [title, entries]
  end

end
