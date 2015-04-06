# -*- encoding : utf-8 -*-
require 'rails_helper'

describe RssFeedGetTopXEntriesAndTitle do

  it 'get_top_x_entries_and_title with 3 entries' do
    # TODO soeren 06.04.15 mocken nicht wirkilich gegen den RSS Feed laufen

    result = RssFeedGetTopXEntriesAndTitle.call(rss_feed_url: RSS_FEED_URL, entry_size: 3)
    expect(result.title).to be_present
    expect(result.entries.size).to eq(3)
  end

end