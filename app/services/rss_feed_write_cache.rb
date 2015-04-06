# -*- encoding : utf-8 -*-

# den Feed holen und in eine Datei abspeichern,
# nach 55min erst erneut holen
class RssFeedWriteCache < BaseService

  attribute :rss_feed_url, String

  def call
    write_rss_feed_cache_xml_file
  end

  private

  def write_rss_feed_cache_xml_file
    Rails.logger.info('CHECK RSS-FEED-XML-FILE')
    file = cache_file
    begin
      if cache_time_out?(file)
        Rails.logger.info('DELETE OLD RSS-FEED-XML-FILE')
        File.delete(file)
      end

      unless File.exists?(file)
        feed_data = parse_feed
        if feed_data.present?
          Rails.logger.info('WRITE NEW RSS-FEED-XML-FILE')
          File.open(file, 'wb+') do |f|
            f.write feed_data
          end
        end
      end
    rescue Exception => e
      Rails.logger.error("Error by grab RSS-Feed : #{e.to_s}")
    end

    file
  end

  def cache_time_out
    55.minutes.ago
  end

  def cache_time_out?(file)
    File.exists?(file) && File.mtime(file) < cache_time_out
  end

  def cache_file
    File.join(File.expand_path(Rails.root), 'tmp', 'rss_feed_cache.xml')
  end

  def parse_feed
    Feedjira::Feed.fetch_raw(rss_feed_url)
  end



end