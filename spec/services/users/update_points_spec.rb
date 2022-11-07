# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Users::UpdatePoints do

  subject { Users::UpdatePoints }

  describe 'calculate user points' do
    before :each do
      Game.destroy_all
      Tip.destroy_all
      User.destroy_all

      winner_team    = create(:team, :name => 'winner')
      no_winner_team = create(:team, :name => 'no winner')

      @game1 = create(:game,  :team1_goals => 0, :team2_goals => 0)
      @game2 = create(:game,  :team1_goals => 1, :team2_goals => 0)
      @game3 = create(:game,  :team1_goals => 0, :team2_goals => 1)
      @game4 = create(:game,  :team1_goals => 2, :team2_goals => 1)
      @game5 = create(:final, :team1_goals => 0, :team2_goals => 3, :team1 => no_winner_team, :team2 => winner_team)

      # erwartet 8 Punkte (8, 0, 0, 0, 0)
      @user1 = create_active_user
      create(:tip, :user => @user1, :game => @game1, :team1_goals => 0, :team2_goals => 0)
      create(:tip, :user => @user1, :game => @game2, :team1_goals => 0, :team2_goals => 0)
      create(:tip, :user => @user1, :game => @game3, :team1_goals => 0, :team2_goals => 0)
      create(:tip, :user => @user1, :game => @game4, :team1_goals => 0, :team2_goals => 0)
      create(:tip, :user => @user1, :game => @game5, :team1_goals => 0, :team2_goals => 0)

      # erwartet 20 Punkte (8, 4, 0, 0, 0) + SIegertipp richtig (8 Punkte)
      @user2 = create_active_user(create(:user, :bonus_champion_team_id => winner_team.id))
      create(:tip, :user => @user2, :game => @game1, :team1_goals => 0, :team2_goals => 0)
      create(:tip, :user => @user2, :game => @game2, :team1_goals => 3, :team2_goals => 2)
      create(:tip, :user => @user2, :game => @game3, :team1_goals => 0, :team2_goals => 0)
      create(:tip, :user => @user2, :game => @game4, :team1_goals => 0, :team2_goals => 0)
      create(:tip, :user => @user2, :game => @game5, :team1_goals => 0, :team2_goals => 0)

      # erwartet 13 Punkte (8, 0, 0, 0, 5)
      @user3 = create_active_user
      create(:tip, :user => @user3, :game => @game1, :team1_goals => 0, :team2_goals => 0)
      create(:tip, :user => @user3, :game => @game2, :team1_goals => 0, :team2_goals => 0)
      create(:tip, :user => @user3, :game => @game3, :team1_goals => 0, :team2_goals => 0)
      create(:tip, :user => @user3, :game => @game4, :team1_goals => 0, :team2_goals => 0)
      create(:tip, :user => @user3, :game => @game5, :team1_goals => 0, :team2_goals => 1)

      # erwartet 21 Punkte (8, 0, 0, 0, 5) + richtigen Siegertip (8)
      @user4 = create_active_user(create(:user, :bonus_champion_team_id => winner_team.id))
      create(:tip, :user => @user4, :game => @game1, :team1_goals => 0, :team2_goals => 0)
      create(:tip, :user => @user4, :game => @game2, :team1_goals => 0, :team2_goals => 0)
      create(:tip, :user => @user4, :game => @game3, :team1_goals => 0, :team2_goals => 0)
      create(:tip, :user => @user4, :game => @game4, :team1_goals => 0, :team2_goals => 0)
      create(:tip, :user => @user4, :game => @game5, :team1_goals => 0, :team2_goals => 2)

      # Alles richtig getipt + richtigen Siegertip  (48 Punkte)
      @user5 = create_active_user(create(:user, :bonus_champion_team_id => winner_team.id))
      create(:tip, :user => @user5, :game => @game1, :team1_goals => 0, :team2_goals => 0)
      create(:tip, :user => @user5, :game => @game2, :team1_goals => 1, :team2_goals => 0)
      create(:tip, :user => @user5, :game => @game3, :team1_goals => 0, :team2_goals => 1)
      create(:tip, :user => @user5, :game => @game4, :team1_goals => 2, :team2_goals => 1)
      create(:tip, :user => @user5, :game => @game5, :team1_goals => 0, :team2_goals => 3)

      # hat keinen Tipp abgegeben - 0 Punkte
      @user6 = create_active_user(create(:user, :bonus_champion_team_id => nil))
      create(:tip, :user => @user6, :game => @game1, :team1_goals => nil, :team2_goals => nil)
      create(:tip, :user => @user6, :game => @game2, :team1_goals => nil, :team2_goals => nil)
      create(:tip, :user => @user6, :game => @game3, :team1_goals => nil, :team2_goals => nil)
      create(:tip, :user => @user6, :game => @game4, :team1_goals => nil, :team2_goals => nil)
      create(:tip, :user => @user6, :game => @game5, :team1_goals => nil, :team2_goals => nil)
    end

    it 'after first game finished' do
      @game1.update_attribute(:finished, true)

      Tips::UpdatePoints.call
      subject.call

      user = User.find(@user1.id)
      expect(user.points).to eq(8)
      expect(user.bonus_points).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(0)

      user = User.find(@user2.id)
      expect(user.points).to eq(8)
      expect(user.bonus_points).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(0)

      user = User.find(@user3.id)
      expect(user.points).to eq(8)
      expect(user.bonus_points).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(0)

      user = User.find(@user4.id)
      expect(user.points).to eq(8)
      expect(user.bonus_points).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(0)

      user = User.find(@user5.id)
      expect(user.points).to eq(8)
      expect(user.bonus_points).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(0)

      user = User.find(@user6.id)
      expect(user.points).to eq(0)
      expect(user.bonus_points).to eq(0)
      expect(user.count8points).to eq(0)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(1)

    end

    it 'after first two games finished' do
      @game1.update_attribute(:finished, true)
      @game2.update_attribute(:finished, true)

      Tips::UpdatePoints.call
      subject.call

      user = User.find(@user1.id)
      expect(user.points).to eq(8)
      expect(user.bonus_points).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(1)

      user = User.find(@user2.id)
      expect(user.points).to eq(12)
      expect(user.bonus_points).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(1)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(0)

      user = User.find(@user3.id)
      expect(user.points).to eq(8)
      expect(user.bonus_points).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(1)

      user = User.find(@user4.id)
      expect(user.points).to eq(8)
      expect(user.bonus_points).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(1)

      user = User.find(@user5.id)
      expect(user.points).to eq(16)
      expect(user.bonus_points).to eq(0)
      expect(user.count8points).to eq(2)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(0)

      user = User.find(@user6.id)
      expect(user.points).to eq(0)
      expect(user.bonus_points).to eq(0)
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

      Tips::UpdatePoints.call
      subject.call

      user = User.find(@user1.id)
      expect(user.points).to eq(8)
      expect(user.bonus_points).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(4)

      user = User.find(@user2.id)
      expect(user.points).to eq(20)
      expect(user.bonus_points).to eq(8)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(1)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(3)

      user = User.find(@user3.id)
      expect(user.points).to eq(13)
      expect(user.bonus_points).to eq(0)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(1)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(3)

      user = User.find(@user4.id)
      expect(user.points).to eq(21)
      expect(user.bonus_points).to eq(8)
      expect(user.count8points).to eq(1)
      expect(user.count5points).to eq(1)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(3)

      user = User.find(@user5.id)
      expect(user.points).to eq(48)
      expect(user.bonus_points).to eq(8)
      expect(user.count8points).to eq(5)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(0)

      user = User.find(@user6.id)
      expect(user.points).to eq(0)
      expect(user.bonus_points).to eq(0)
      expect(user.count8points).to eq(0)
      expect(user.count5points).to eq(0)
      expect(user.count4points).to eq(0)
      expect(user.count3points).to eq(0)
      expect(user.count0points).to eq(5)
    end

  end

end
