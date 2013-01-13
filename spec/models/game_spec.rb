# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Game do

  it "should use Factory" do
      game = Factory(:game)
      game.team1.should be_present
      game.team2.should be_present
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
    lambda{Game.create!({:start_at => "19.06.2012 20:45", :place => "Ort", :team1_id => 1, :group=> "D", :round => Game::GROUP})}.should raise_error(ActiveRecord::RecordInvalid)
    lambda{Game.create!({:start_at => "19.06.2012 20:45", :place => "Ort", :team2_id => 2, :group=> "D", :round => Game::GROUP})}.should raise_error(ActiveRecord::RecordInvalid)
    lambda{Game.create!({:start_at => "19.06.2012 20:45", :place => "Ort", :team1_placeholder_name => "test1", :group=> "D", :round => Game::GROUP})}.should raise_error(ActiveRecord::RecordInvalid)
    lambda{Game.create!({:start_at => "19.06.2012 20:45", :place => "Ort", :team2_placeholder_name => "test2", :group=> "D", :round => Game::GROUP})}.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "should get finished days with game ids" do
    day1_game1 = Factory(:game, :start_at => "19.06.2012 20:45", :finished => true)
    day1_game2 = Factory(:game, :start_at => "19.06.2012 20:45", :finished => true)
    day1_game3 = Factory(:game, :start_at => "19.06.2012 20:45", :finished => true)

    day2_game1 = Factory(:game, :start_at => "20.06.2012 18:00", :finished => true)
    day2_game2 = Factory(:game, :start_at => "20.06.2012 18:00", :finished => true)
    day2_game3 = Factory(:game, :start_at => "20.06.2012 20:45", :finished => false)

    day3_game1 = Factory(:game, :start_at => "21.06.2012 18:00", :finished => true)
    day3_game2 = Factory(:game, :start_at => "21.06.2012 18:00", :finished => false)
    day3_game3 = Factory(:game, :start_at => "21.06.2012 20:45", :finished => true)

    game_days_with_game_ids = Game.finished_days_with_game_ids
    game_days_with_game_ids["2012-06-19"].sort.should == [day1_game1.id, day1_game2.id, day1_game3.id].sort
    game_days_with_game_ids["2012-06-20"].should be_nil
    game_days_with_game_ids["2012-06-21"].should be_nil

    day2_game3.update_attribute(:finished, true)
    game_days_with_game_ids = Game.finished_days_with_game_ids
    game_days_with_game_ids["2012-06-19"].sort.should == [day1_game1.id, day1_game2.id, day1_game3.id].sort
    game_days_with_game_ids["2012-06-20"].sort.should == [day2_game1.id, day2_game2.id, day2_game3.id].sort
    game_days_with_game_ids["2012-06-21"].should be_nil

  end
end
