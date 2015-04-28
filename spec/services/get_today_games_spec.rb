# -*- encoding : utf-8 -*-
require 'rails_helper'

describe GetTodayGames do

  let(:time_now) { Time.parse('19.06.2014 22:00') }

  let(:yesterday_game)  { FactoryGirl.create(:game, :start_at => time_now - 1.day) }          # gestern 22:00

  let(:today_game1)     { FactoryGirl.create(:game, :start_at => time_now.midnight) }         # heute 00:00
  let(:today_game2)     { FactoryGirl.create(:game, :start_at => time_now) }                  # heute 22:00
  let(:today_game3)     { FactoryGirl.create(:game, :start_at => time_now.midnight + 1.day) } # heute 24:00

  let(:tommorrow_game1) { FactoryGirl.create(:game, :start_at => time_now + 1.day) }          # morgen 22:00
  let(:tommorrow_game2) { FactoryGirl.create(:game, :start_at => time_now.midnight + 2.day) } # morgen 24:00

  before :each do

  end

  it 'should get games from today at 00:10' do
    expected = [today_game1, today_game2, today_game3]
    Timecop.freeze(time_now.midnight + 10.minutes)
    expect(GetTodayGames.call.to_a).to eq(expected)
  end

  it 'should get games from today at 22:00' do
    expected = [today_game1, today_game2, today_game3]
    Timecop.freeze(time_now)
    expect(GetTodayGames.call.to_a).to eq(expected)
  end

  it 'should get games from tommorrow at 22:00' do
    expected = [today_game3, tommorrow_game1, tommorrow_game2]
    Timecop.freeze(time_now + 1.day)
    expect(GetTodayGames.call.to_a).to eq(expected)
  end

  it 'should get games from yesterday at 22:00' do
    expected = [yesterday_game.id, today_game1.id]
    Timecop.freeze(time_now - 1.day)
    expect(GetTodayGames.call.pluck(:id)).to eq(expected)

  end

end