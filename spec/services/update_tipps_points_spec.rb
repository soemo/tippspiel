# -*- encoding : utf-8 -*-
require 'rails_helper'

describe UpdateTippsPoints do

  def ctp_call_helper(game_winner, game_team1_goals, game_team2_goals, tipp_team1_goals, tipp_team2_goals)
     UpdateTippsPoints.new.send('calculate_tipp_points', game_winner, game_team1_goals, game_team2_goals, tipp_team1_goals, tipp_team2_goals)
  end

  it 'get correct tipp points' do
    #calculate_tipp_points(game_winner, game_team1_goals, game_team2_goals, tipp_team1_goals, tipp_team2_goals)
    expect(ctp_call_helper(Game::TEAM1_WIN, 1, 0, 1, 0)).to eq(8)
    expect(ctp_call_helper(Game::TEAM1_WIN, 2, 0, 1, 0)).to eq(5)
    expect(ctp_call_helper(Game::TEAM1_WIN, 2, 1, 1, 0)).to eq(4)
    expect(ctp_call_helper(Game::TEAM1_WIN, 3, 1, 1, 0)).to eq(3)
    expect(ctp_call_helper(Game::TEAM1_WIN, 3, 1, 0, 1)).to eq(0)
    expect(ctp_call_helper(Game::TEAM1_WIN, 3, 1, 1, 1)).to eq(0)
    expect(ctp_call_helper(Game::TEAM1_WIN, 4, 2, 3, 2)).to eq(5)
    expect(ctp_call_helper(Game::TEAM1_WIN, 4, 2, 2, 0)).to eq(4)
    expect(ctp_call_helper(Game::TEAM1_WIN, 4, 2, 2, 1)).to eq(3)
    expect(ctp_call_helper(Game::TEAM1_WIN, 2, 1, 1, 1)).to eq(0)

    expect(ctp_call_helper(Game::TEAM2_WIN, 0, 1, 0, 1)).to eq(8)
    expect(ctp_call_helper(Game::TEAM2_WIN, 0, 1, 0, 2)).to eq(5)
    expect(ctp_call_helper(Game::TEAM2_WIN, 0, 1, 1, 2)).to eq(4)
    expect(ctp_call_helper(Game::TEAM2_WIN, 0, 1, 1, 3)).to eq(3)
    expect(ctp_call_helper(Game::TEAM2_WIN, 0, 2, 1, 2)).to eq(5)
    expect(ctp_call_helper(Game::TEAM2_WIN, 0, 1, 1, 1)).to eq(0)
    expect(ctp_call_helper(Game::TEAM2_WIN, 0, 3, 1, 2)).to eq(3)

    expect(ctp_call_helper(Game::UNENTSCHIEDEN, 0, 0, 0, 0)).to eq(8)
    expect(ctp_call_helper(Game::UNENTSCHIEDEN, 0, 0, 1, 1)).to eq(4)
    expect(ctp_call_helper(Game::UNENTSCHIEDEN, 0, 0, 2, 1)).to eq(0)
    expect(ctp_call_helper(Game::UNENTSCHIEDEN, 0, 0, 1, 2)).to eq(0)
  end


  describe 'calculate all user tipp points' do

    before :each do
      Game.destroy_all
      Tipp.destroy_all
      User.destroy_all

      @game1 = FactoryGirl.create(:game, :team1_goals => 0, :team2_goals => 0)
      @game2 = FactoryGirl.create(:game, :team1_goals => 1, :team2_goals => 0)
      @game3 = FactoryGirl.create(:game, :team1_goals => 0, :team2_goals => 1)
      @game4 = FactoryGirl.create(:game, :team1_goals => 2, :team2_goals => 1)
      @game5 = FactoryGirl.create(:game, :team1_goals => 0, :team2_goals => 3)

      @user1 = create_active_user
      @user2 = create_active_user
      @user3 = create_active_user
      @user4 = create_active_user
      @user5 = create_active_user

      User.all.each do |user|
        Game.all.each do |game|
          create(:tipp, :user => user, :game => game,
                 :team1_goals => rand(4), :team2_goals => rand(4))
        end
      end
    end

    it 'should update all tipp points for a game' do
      expect(Tipp.where(:game_id => @game1.id).size).to eq(5)
      where_sql = ["game_id = ? and tipp_punkte is not null", @game1.id]
      tipps = Tipp.where(where_sql).to_a
      expect(tipps).not_to be_present

      UpdateTippsPoints.new.send('update_all_tipp_points_for', @game1)

      tipps = Tipp.where(where_sql).to_a
      expect(tipps).to be_present
      tipps.size == 5
    end

    it 'should update all tipp points for all games' do
      where_sql = ["tipp_punkte is not null"]
      expect(Tipp.where(where_sql).count).to eq(0)

      UpdateTippsPoints.call

      # noch keine Tipp Punkte vergeben, da noch kein Spiel beendet
      expect(Tipp.where(where_sql).count).to eq(0)

      Game.first.update_column(:finished, true)
      UpdateTippsPoints.call
      # Tipp Punkte fürs erste Spiel vergeben
      expect(Tipp.where(where_sql).count).to eq(5)

      Game.update_all("finished=true")
      UpdateTippsPoints.call
      # alleTipp Punkte vergeben
      expect(Tipp.where(["tipp_punkte is null"]).count).to eq(0)
    end
  end

end