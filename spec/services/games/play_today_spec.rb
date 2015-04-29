# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Games::PlayToday do

  let(:time_now) { Time.parse('19.06.2014 22:00') }

  let(:yesterday_game)  { FactoryGirl.create(:game, :start_at => time_now - 1.day) }          # gestern 22:00

  let(:today_game1)     { FactoryGirl.create(:game, :start_at => time_now.midnight) }         # heute 00:00
  let(:today_game2)     { FactoryGirl.create(:game, :start_at => time_now) }                  # heute 22:00
  let(:today_game3)     { FactoryGirl.create(:game, :start_at => time_now.midnight + 1.day) } # heute 24:00

  let(:tommorrow_game1) { FactoryGirl.create(:game, :start_at => time_now + 1.day) }          # morgen 22:00
  let(:tommorrow_game2) { FactoryGirl.create(:game, :start_at => time_now.midnight + 2.day) } # morgen 24:00

  subject { Games::PlayToday }

  before :each do

  end

  it 'gets games from today at 00:10' do
    expected = [today_game1, today_game2, today_game3]
    Timecop.freeze(time_now.midnight + 10.minutes)
    expect(subject.call.to_a).to eq(expected)
  end

  it 'gets games from today at 22:00' do
    expected = [today_game1, today_game2, today_game3]
    Timecop.freeze(time_now)
    expect(subject.call.to_a).to eq(expected)
  end

  it 'gets games from tommorrow at 22:00' do
    expected = [today_game3, tommorrow_game1, tommorrow_game2]
    Timecop.freeze(time_now + 1.day)
    expect(subject.call.to_a).to eq(expected)
  end

  it 'gets games from yesterday at 22:00' do
    expected = [yesterday_game.id, today_game1.id]
    Timecop.freeze(time_now - 1.day)
    expect(subject.call.pluck(:id)).to eq(expected)

  end

end