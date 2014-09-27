# -*- encoding : utf-8 -*-
require 'rails_helper'

describe CalculatePoints do

  include CalculatePoints

  it 'should get correct tipp points' do
    #calculate_tipp_points(game_winner, game_team1_goals, game_team2_goals, tipp_team1_goals, tipp_team2_goals)
    expect(calculate_tipp_points(Game::TEAM1_WIN, 1, 0, 1, 0)).to eq(8)
    expect(calculate_tipp_points(Game::TEAM1_WIN, 2, 0, 1, 0)).to eq(5)
    expect(calculate_tipp_points(Game::TEAM1_WIN, 2, 1, 1, 0)).to eq(4)
    expect(calculate_tipp_points(Game::TEAM1_WIN, 3, 1, 1, 0)).to eq(3)
    expect(calculate_tipp_points(Game::TEAM1_WIN, 3, 1, 0, 1)).to eq(0)
    expect(calculate_tipp_points(Game::TEAM1_WIN, 3, 1, 1, 1)).to eq(0)
    expect(calculate_tipp_points(Game::TEAM1_WIN, 4, 2, 3, 2)).to eq(5)
    expect(calculate_tipp_points(Game::TEAM1_WIN, 4, 2, 2, 0)).to eq(4)
    expect(calculate_tipp_points(Game::TEAM1_WIN, 4, 2, 2, 1)).to eq(3)
    expect(calculate_tipp_points(Game::TEAM1_WIN, 2, 1, 1, 1)).to eq(0)

    expect(calculate_tipp_points(Game::TEAM2_WIN, 0, 1, 0, 1)).to eq(8)
    expect(calculate_tipp_points(Game::TEAM2_WIN, 0, 1, 0, 2)).to eq(5)
    expect(calculate_tipp_points(Game::TEAM2_WIN, 0, 1, 1, 2)).to eq(4)
    expect(calculate_tipp_points(Game::TEAM2_WIN, 0, 1, 1, 3)).to eq(3)
    expect(calculate_tipp_points(Game::TEAM2_WIN, 0, 2, 1, 2)).to eq(5)
    expect(calculate_tipp_points(Game::TEAM2_WIN, 0, 1, 1, 1)).to eq(0)
    expect(calculate_tipp_points(Game::TEAM2_WIN, 0, 3, 1, 2)).to eq(3)

    expect(calculate_tipp_points(Game::UNENTSCHIEDEN, 0, 0, 0, 0)).to eq(8)
    expect(calculate_tipp_points(Game::UNENTSCHIEDEN, 0, 0, 1, 1)).to eq(4)
    expect(calculate_tipp_points(Game::UNENTSCHIEDEN, 0, 0, 2, 1)).to eq(0)
    expect(calculate_tipp_points(Game::UNENTSCHIEDEN, 0, 0, 1, 2)).to eq(0)
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
          FactoryGirl.create(:tipp, :user => user, :game => game, :team1_goals => rand(4), :team2_goals => rand(4))
        end
      end

    end

    it 'should update all tipp points for a game' do
      expect(Tipp.where(:game_id => @game1.id).size).to eq(5)
      where_sql = ["game_id = ? and tipp_punkte is not null", @game1.id]
      tipps = Tipp.where(where_sql).to_a
      expect(tipps).not_to be_present

      update_all_tipp_points_for(@game1)

      tipps = tipps = Tipp.where(where_sql).to_a
      expect(tipps).to be_present
      tipps.size == 5
    end

    it 'should update all tipp points for all games' do
      where_sql = ["tipp_punkte is not null"]
      expect(Tipp.where(where_sql).count).to eq(0)

      calculate_all_user_tipp_points

      # noch keine Tipp Punkte vergeben, da noch kein Spiel beendet
      expect(Tipp.where(where_sql).count).to eq(0)

      Game.first.update_column(:finished, true)
      calculate_all_user_tipp_points
      # Tipp Punkte fürs erste Spiel vergeben
      expect(Tipp.where(where_sql).count).to eq(5)

      Game.update_all("finished=true")
      calculate_all_user_tipp_points
      # alleTipp Punkte vergeben
      expect(Tipp.where(["tipp_punkte is null"]).count).to eq(0)
    end
  end

  describe 'calculate user points' do
    before :each do
      Game.destroy_all
      Tipp.destroy_all
      User.destroy_all

      winner_team    = FactoryGirl.create(:team, :name => 'winner')
      no_winner_team = FactoryGirl.create(:team, :name => 'no winner')

      @game1 = FactoryGirl.create(:game,  :team1_goals => 0, :team2_goals => 0)
      @game2 = FactoryGirl.create(:game,  :team1_goals => 1, :team2_goals => 0)
      @game3 = FactoryGirl.create(:game,  :team1_goals => 0, :team2_goals => 1)
      @game4 = FactoryGirl.create(:game,  :team1_goals => 2, :team2_goals => 1)
      @game5 = FactoryGirl.create(:final, :team1_goals => 0, :team2_goals => 3, :team1 => no_winner_team, :team2 => winner_team)

      # erwartet 8 Punkte (8, 0, 0, 0, 0)
      @user1 = create_active_user
      FactoryGirl.create(:tipp, :user => @user1, :game => @game1, :team1_goals => 0, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user1, :game => @game2, :team1_goals => 0, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user1, :game => @game3, :team1_goals => 0, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user1, :game => @game4, :team1_goals => 0, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user1, :game => @game5, :team1_goals => 0, :team2_goals => 0)

      # erwartet 20 Punkte (8, 4, 0, 0, 0) + SIegertipp richtig (8 Punkte)
      @user2 = create_active_user(FactoryGirl.create(:user, :championtipp_team_id => winner_team.id))
      FactoryGirl.create(:tipp, :user => @user2, :game => @game1, :team1_goals => 0, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user2, :game => @game2, :team1_goals => 3, :team2_goals => 2)
      FactoryGirl.create(:tipp, :user => @user2, :game => @game3, :team1_goals => 0, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user2, :game => @game4, :team1_goals => 0, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user2, :game => @game5, :team1_goals => 0, :team2_goals => 0)

      # erwartet 13 Punkte (8, 0, 0, 0, 5)
      @user3 = create_active_user
      FactoryGirl.create(:tipp, :user => @user3, :game => @game1, :team1_goals => 0, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user3, :game => @game2, :team1_goals => 0, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user3, :game => @game3, :team1_goals => 0, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user3, :game => @game4, :team1_goals => 0, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user3, :game => @game5, :team1_goals => 0, :team2_goals => 1)

      # erwartet 21 Punkte (8, 0, 0, 0, 5) + richtigen Siegertipp (8)
      @user4 = create_active_user(FactoryGirl.create(:user, :championtipp_team_id => winner_team.id))
      FactoryGirl.create(:tipp, :user => @user4, :game => @game1, :team1_goals => 0, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user4, :game => @game2, :team1_goals => 0, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user4, :game => @game3, :team1_goals => 0, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user4, :game => @game4, :team1_goals => 0, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user4, :game => @game5, :team1_goals => 0, :team2_goals => 2)

      # Alles richtig getippt + richtigen Siegertipp  (48 Punkte)
      @user5 = create_active_user(FactoryGirl.create(:user, :championtipp_team_id => winner_team.id))
      FactoryGirl.create(:tipp, :user => @user5, :game => @game1, :team1_goals => 0, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user5, :game => @game2, :team1_goals => 1, :team2_goals => 0)
      FactoryGirl.create(:tipp, :user => @user5, :game => @game3, :team1_goals => 0, :team2_goals => 1)
      FactoryGirl.create(:tipp, :user => @user5, :game => @game4, :team1_goals => 2, :team2_goals => 1)
      FactoryGirl.create(:tipp, :user => @user5, :game => @game5, :team1_goals => 0, :team2_goals => 3)

      # hat keinen Tipp abgegeben - 0 Punkte
      @user6 = create_active_user(FactoryGirl.create(:user, :championtipp_team_id => nil))
      FactoryGirl.create(:tipp, :user => @user6, :game => @game1, :team1_goals => nil, :team2_goals => nil)
      FactoryGirl.create(:tipp, :user => @user6, :game => @game2, :team1_goals => nil, :team2_goals => nil)
      FactoryGirl.create(:tipp, :user => @user6, :game => @game3, :team1_goals => nil, :team2_goals => nil)
      FactoryGirl.create(:tipp, :user => @user6, :game => @game4, :team1_goals => nil, :team2_goals => nil)
      FactoryGirl.create(:tipp, :user => @user6, :game => @game5, :team1_goals => nil, :team2_goals => nil)
    end

    it 'after first game finished' do
      @game1.update_attribute(:finished, true)

      calculate_all_user_tipp_points
      calculate_user_points

      user = User.find(@user1.id)
      expect(user.points).to eq(8)
      expect(user.championtipppoints).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(0)

      user = User.find(@user2.id)
      expect(user.points).to eq(8)
      expect(user.championtipppoints).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(0)

      user = User.find(@user3.id)
      expect(user.points).to eq(8)
      expect(user.championtipppoints).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(0)

      user = User.find(@user4.id)
      expect(user.points).to eq(8)
      expect(user.championtipppoints).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(0)

      user = User.find(@user5.id)
      expect(user.points).to eq(8)
      expect(user.championtipppoints).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(0)

      user = User.find(@user6.id)
      expect(user.points).to eq(0)
      expect(user.championtipppoints).to eq(0)
      expect(user.count8points).to eq(0)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(1)

    end

    it 'after first two games finished' do
      @game1.update_attribute(:finished, true)
      @game2.update_attribute(:finished, true)

      calculate_all_user_tipp_points
      calculate_user_points

      user = User.find(@user1.id)
      expect(user.points).to eq(8)
      expect(user.championtipppoints).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(1)

      user = User.find(@user2.id)
      expect(user.points).to eq(12)
      expect(user.championtipppoints).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(1)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(0)

      user = User.find(@user3.id)
      expect(user.points).to eq(8)
      expect(user.championtipppoints).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(1)

      user = User.find(@user4.id)
      expect(user.points).to eq(8)
      expect(user.championtipppoints).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(1)

      user = User.find(@user5.id)
      expect(user.points).to eq(16)
      expect(user.championtipppoints).to eq(0)
      expect(user.count8points).to eq(2)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(0)

      user = User.find(@user6.id)
      expect(user.points).to eq(0)
      expect(user.championtipppoints).to eq(0)
      expect(user.count8points).to eq(0)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(2)
    end

    it 'after tournament is finished' do
      @game1.update_attribute(:finished, true)
      @game2.update_attribute(:finished, true)
      @game3.update_attribute(:finished, true)
      @game4.update_attribute(:finished, true)
      @game5.update_attribute(:finished, true)

      calculate_all_user_tipp_points
      calculate_user_points

      user = User.find(@user1.id)
      expect(user.points).to eq(8)
      expect(user.championtipppoints).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(4)

      user = User.find(@user2.id)
      expect(user.points).to eq(20)
      expect(user.championtipppoints).to eq(8)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(1)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(3)

      user = User.find(@user3.id)
      expect(user.points).to eq(13)
      expect(user.championtipppoints).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(1)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(3)

      user = User.find(@user4.id)
      expect(user.points).to eq(21)
      expect(user.championtipppoints).to eq(8)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(1)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(3)

      user = User.find(@user5.id)
      expect(user.points).to eq(48)
      expect(user.championtipppoints).to eq(8)
      expect(user.count8points).to eq(5)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(0)

      user = User.find(@user6.id)
      expect(user.points).to eq(0)
      expect(user.championtipppoints).to eq(0)
      expect(user.count8points).to eq(0)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(5)
    end

  end

end
