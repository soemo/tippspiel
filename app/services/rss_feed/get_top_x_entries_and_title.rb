# -*- encoding : utf-8 -*-
module RssFeed
  class GetTopXEntriesAndTitle < BaseService

    attribute :rss_feed_url, String
    attribute :entry_size, Integer, default: 5

    Result = Struct.new(:title, :entries)

    def call
      title = ''
      entries = []
      feed = parse
      if feed.present?
        title = feed.title
        entries = feed.entries[0...entry_size]
      end

      Result.new(title, entries)
    end

    private

    def parse
      result = nil
      file   = RssFeed::WriteCache.call(rss_feed_url: rss_feed_url)
      result = Feedjira::Parser::RSS.parse(File.read(file)) if File.exists?(file)

      result
    end

  end
end