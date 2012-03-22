require 'spec_helper'

describe Game do

  it "should use Factory" do
      game = Factory(:game)
      game.team1.should be_present
      game.team2.should be_present
  end

  it "should create" do
    Game.create!({:start_at => "19.06.2012 20:45", :place => "Ort", :team1_id => 1, :team2_id => 2, :group=> "D", :round => Game::GROUP})
    Game.create!({:start_at => "19.06.2012 20:45", :place => "Ort", :team1_placeholder_name => "D2", :team2_placeholder_name => "D3", :group=> "D", :round => Game::GROUP})
  end

  it "should not create" do
    lambda{Game.create!({:start_at => "19.06.2012 20:45", :place => "Ort", :team1_id => 1, :group=> "D", :round => Game::GROUP})}.should raise_error(ActiveRecord::RecordInvalid)
    lambda{Game.create!({:start_at => "19.06.2012 20:45", :place => "Ort", :team2_id => 2, :group=> "D", :round => Game::GROUP})}.should raise_error(ActiveRecord::RecordInvalid)
    lambda{Game.create!({:start_at => "19.06.2012 20:45", :place => "Ort", :team1_placeholder_name => "test1", :group=> "D", :round => Game::GROUP})}.should raise_error(ActiveRecord::RecordInvalid)
    lambda{Game.create!({:start_at => "19.06.2012 20:45", :place => "Ort", :team2_placeholder_name => "test2", :group=> "D", :round => Game::GROUP})}.should raise_error(ActiveRecord::RecordInvalid)
  end
end
