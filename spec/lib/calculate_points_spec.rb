require 'spec_helper'

describe CalculatePoints do

  include CalculatePoints

  it "should get correct tipp points" do
    #calculate_tipp_points(game_winner, game_team1_goals, game_team2_goals, tipp_team1_goals, tipp_team2_goals)
    calculate_tipp_points(Game::TEAM1_WIN, 1, 0, 1, 0).should == 6
    calculate_tipp_points(Game::TEAM1_WIN, 2, 0, 1, 0).should == 4
    calculate_tipp_points(Game::TEAM1_WIN, 2, 1, 1, 0).should == 4
    calculate_tipp_points(Game::TEAM1_WIN, 3, 1, 1, 0).should == 3
    calculate_tipp_points(Game::TEAM1_WIN, 3, 1, 0, 1).should == 0
    calculate_tipp_points(Game::TEAM1_WIN, 3, 1, 1, 1).should == 0
    calculate_tipp_points(Game::TEAM1_WIN, 4, 2, 3, 2).should == 4
    calculate_tipp_points(Game::TEAM1_WIN, 4, 2, 2, 0).should == 4
    calculate_tipp_points(Game::TEAM1_WIN, 4, 2, 2, 1).should == 3
    calculate_tipp_points(Game::TEAM1_WIN, 2, 1, 1, 1).should == 0

    calculate_tipp_points(Game::TEAM2_WIN, 0, 1, 0, 1).should == 6
    calculate_tipp_points(Game::TEAM2_WIN, 0, 1, 0, 2).should == 4
    calculate_tipp_points(Game::TEAM2_WIN, 0, 1, 1, 2).should == 4
    calculate_tipp_points(Game::TEAM2_WIN, 0, 1, 1, 3).should == 3
    calculate_tipp_points(Game::TEAM2_WIN, 0, 2, 1, 2).should == 4
    calculate_tipp_points(Game::TEAM2_WIN, 0, 1, 1, 1).should == 0
    calculate_tipp_points(Game::TEAM2_WIN, 0, 3, 1, 2).should == 3

    calculate_tipp_points(Game::UNENTSCHIEDEN, 0, 0, 0, 0).should == 6
    calculate_tipp_points(Game::UNENTSCHIEDEN, 0, 0, 1, 1).should == 4
    calculate_tipp_points(Game::UNENTSCHIEDEN, 0, 0, 2, 1).should == 0
    calculate_tipp_points(Game::UNENTSCHIEDEN, 0, 0, 1, 2).should == 0
  end

  describe "calculate all user tipp points" do
    before :each do
      Game.destroy_all
      Tipp.destroy_all
      User.destroy_all

      @game1 = Factory(:game, :team1_goals => 0, :team2_goals => 0)
      @game2 = Factory(:game, :team1_goals => 1, :team2_goals => 0)
      @game3 = Factory(:game, :team1_goals => 0, :team2_goals => 1)
      @game4 = Factory(:game, :team1_goals => 2, :team2_goals => 1)
      @game5 = Factory(:game, :team1_goals => 0, :team2_goals => 3)

      @user1 = Factory(:user)
      @user2 = Factory(:user)
      @user3 = Factory(:user)
      @user4 = Factory(:user)
      @user5 = Factory(:user)

      User.all.each do |user|
        Game.all.each do |game|
          Factory(:tipp, :user => user, :game => game, :team1_goals => rand(4), :team2_goals => rand(4))
        end
      end

    end

    it "should update all tipp points for a game" do
      Tipp.where(:game_id => @game1.id).size.should == 5
      where_sql = ["game_id = ? and tipp_punkte is not null", @game1.id]
      tipps = Tipp.where(where_sql).all
      tipps.should_not be_present

      update_all_tipp_points_for_game(@game1)

      tipps = tipps = Tipp.where(where_sql).all
      tipps.should be_present
      tipps.size == 5
    end

    it "should update all tipp points for all games" do
      where_sql = ["tipp_punkte is not null"]
      Tipp.where(where_sql).all.size.should == 0

      calculate_all_user_tipp_points

      # noch keine Tipp Punkte vergeben, da noch kein Spiel beendet
      Tipp.where(where_sql).all.size.should == 0

      Game.first.update_attribute(:finished, true)
      calculate_all_user_tipp_points
      # Tipp Punkte fürs erste Spiel vergeben
      Tipp.where(where_sql).all.size.should == 5

      Game.update_all("finished=true")
      calculate_all_user_tipp_points
      # alleTipp Punkte vergeben
      Tipp.where(["tipp_punkte is null"]).all.size.should == 0
    end
  end

end