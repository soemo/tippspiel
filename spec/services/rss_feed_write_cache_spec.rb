# -*- encoding : utf-8 -*-
require 'rails_helper'

describe RssFeedWriteCache do


  context 'write rss file' do

    it 'if no file exists' do
      file = RssFeedWriteCache.new.send('cache_file')
      File.delete(file) if File.exists?(file)
      expect(File.exists?(file)).to be false

      expect(Rails.logger).to     receive(:info).with('CHECK RSS-FEED-XML-FILE')
      expect(Rails.logger).not_to receive(:info).with('DELETE OLD RSS-FEED-XML-FILE')
      expect(Rails.logger).to     receive(:info).with('WRITE NEW RSS-FEED-XML-FILE')

      RssFeedWriteCache.call(rss_feed_url: RSS_FEED_URL)
      expect(File.exists?(file)).to be true

      File.delete(file) if File.exists?(file)
    end

    it 'file older then cache_time_out' do
      file = RssFeedWriteCache.new.send('cache_file')
      cache_time_out = RssFeedWriteCache.new.send('cache_time_out')
      freeze_test_time(cache_time_out - 1.minute)

      expect(Rails.logger).to     receive(:info).with('CHECK RSS-FEED-XML-FILE')
      expect(Rails.logger).not_to receive(:info).with('DELETE OLD RSS-FEED-XML-FILE')
      expect(Rails.logger).to     receive(:info).with('WRITE NEW RSS-FEED-XML-FILE')

      RssFeedWriteCache.call(rss_feed_url: RSS_FEED_URL)
      expect(File.exists?(file)).to be true

      File.delete(file) if File.exists?(file)

    end

  end

  context 'do not write rss file' do

    it 'if file exists and younger then cache_time_out' do
      file = RssFeedWriteCache.new.send('cache_file')
      File.open(file, 'w+') do |f|
        f.write 'dummytext'
      end

      expect(Rails.logger).to receive(:info).with('CHECK RSS-FEED-XML-FILE')
      expect(Rails.logger).not_to receive(:info).with('DELETE OLD RSS-FEED-XML-FILE')
      expect(Rails.logger).not_to receive(:info).with('WRITE NEW RSS-FEED-XML-FILE')

      RssFeedWriteCache.call(rss_feed_url: RSS_FEED_URL)
      expect(File.exists?(file)).to be true

      File.delete(file) if File.exists?(file)
    end

  end
end