# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Game, :type => :model do

  it "should use Factory" do
      game = FactoryGirl.create(:game)
      expect(game.team1).to be_present
      expect(game.team2).to be_present
  end

  it "should create" do
    Game.create!({:start_at => "19.06.2012 20:45", :place => "Ort",
                  :team1_id => 1, :team2_id => 2, :group=> "D",
                  :round => Game::GROUP, :api_match_id => 1})
    Game.create!({:start_at => "19.06.2012 20:45", :place => "Ort",
                  :team1_placeholder_name => "D2", :team2_placeholder_name => "D3",
                  :group=> "D", :round => Game::GROUP, :api_match_id => 2})
  end

  it "should not create" do
    expect{Game.create!({:start_at => "19.06.2012 20:45", :place => "Ort", :team1_id => 1, :group=> "D", :round => Game::GROUP})}.to raise_error(ActiveRecord::RecordInvalid)
    expect{Game.create!({:start_at => "19.06.2012 20:45", :place => "Ort", :team2_id => 2, :group=> "D", :round => Game::GROUP})}.to raise_error(ActiveRecord::RecordInvalid)
    expect{Game.create!({:start_at => "19.06.2012 20:45", :place => "Ort", :team1_placeholder_name => "test1", :group=> "D", :round => Game::GROUP})}.to raise_error(ActiveRecord::RecordInvalid)
    expect{Game.create!({:start_at => "19.06.2012 20:45", :place => "Ort", :team2_placeholder_name => "test2", :group=> "D", :round => Game::GROUP})}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should get finished days with game ids" do
    day1_game1 = FactoryGirl.create(:game, :start_at => "19.06.2012 20:45", :finished => true)
    day1_game2 = FactoryGirl.create(:game, :start_at => "19.06.2012 20:45", :finished => true)
    day1_game3 = FactoryGirl.create(:game, :start_at => "19.06.2012 20:45", :finished => true)

    day2_game1 = FactoryGirl.create(:game, :start_at => "20.06.2012 18:00", :finished => true)
    day2_game2 = FactoryGirl.create(:game, :start_at => "20.06.2012 18:00", :finished => true)
    day2_game3 = FactoryGirl.create(:game, :start_at => "20.06.2012 20:45", :finished => false)

    day3_game1 = FactoryGirl.create(:game, :start_at => "21.06.2012 18:00", :finished => true)
    day3_game2 = FactoryGirl.create(:game, :start_at => "21.06.2012 18:00", :finished => false)
    day3_game3 = FactoryGirl.create(:game, :start_at => "21.06.2012 20:45", :finished => true)

    game_days_with_game_ids = Game.finished_days_with_game_ids
    expect(game_days_with_game_ids["2012-06-19"].sort).to eq([day1_game1.id, day1_game2.id, day1_game3.id].sort)
    expect(game_days_with_game_ids["2012-06-20"]).to be_nil
    expect(game_days_with_game_ids["2012-06-21"]).to be_nil

    day2_game3.update_attribute(:finished, true)
    game_days_with_game_ids = Game.finished_days_with_game_ids
    expect(game_days_with_game_ids["2012-06-19"].sort).to eq([day1_game1.id, day1_game2.id, day1_game3.id].sort)
    expect(game_days_with_game_ids["2012-06-20"].sort).to eq([day2_game1.id, day2_game2.id, day2_game3.id].sort)
    expect(game_days_with_game_ids["2012-06-21"]).to be_nil

  end

  it 'should get finished games' do
     game1 = FactoryGirl.create(:game, :start_at => '19.06.2012 20:45', :finished => nil)
     game2 = FactoryGirl.create(:game, :start_at => '19.06.2012 20:45', :finished => false)
     game3 = FactoryGirl.create(:game, :start_at => '19.06.2012 20:45', :finished => true)

     expect(Game.finished_games).to eq([game3])
  end
end
