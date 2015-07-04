# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Tips::UpdatePoints do

  subject { Tips::UpdatePoints }

  def ctp_call_helper(game_winner, game_team1_goals, game_team2_goals, tip_team1_goals, tip_team2_goals)
    subject.new.send('calculate_tip_points', game_winner, game_team1_goals, game_team2_goals, tip_team1_goals, tip_team2_goals)
  end

  it 'get correct tip points' do
    #calculate_tip_points(game_winner, game_team1_goals, game_team2_goals, tip_team1_goals, tip_team2_goals)
    expect(ctp_call_helper(subject::TEAM1_WIN, 1, 0, 1, 0)).to eq(8)
    expect(ctp_call_helper(subject::TEAM1_WIN, 2, 0, 1, 0)).to eq(5)
    expect(ctp_call_helper(subject::TEAM1_WIN, 2, 1, 1, 0)).to eq(4)
    expect(ctp_call_helper(subject::TEAM1_WIN, 3, 1, 1, 0)).to eq(3)
    expect(ctp_call_helper(subject::TEAM1_WIN, 3, 1, 0, 1)).to eq(0)
    expect(ctp_call_helper(subject::TEAM1_WIN, 3, 1, 1, 1)).to eq(0)
    expect(ctp_call_helper(subject::TEAM1_WIN, 4, 2, 3, 2)).to eq(5)
    expect(ctp_call_helper(subject::TEAM1_WIN, 4, 2, 2, 0)).to eq(4)
    expect(ctp_call_helper(subject::TEAM1_WIN, 4, 2, 2, 1)).to eq(3)
    expect(ctp_call_helper(subject::TEAM1_WIN, 2, 1, 1, 1)).to eq(0)

    expect(ctp_call_helper(subject::TEAM2_WIN, 0, 1, 0, 1)).to eq(8)
    expect(ctp_call_helper(subject::TEAM2_WIN, 0, 1, 0, 2)).to eq(5)
    expect(ctp_call_helper(subject::TEAM2_WIN, 0, 1, 1, 2)).to eq(4)
    expect(ctp_call_helper(subject::TEAM2_WIN, 0, 1, 1, 3)).to eq(3)
    expect(ctp_call_helper(subject::TEAM2_WIN, 0, 2, 1, 2)).to eq(5)
    expect(ctp_call_helper(subject::TEAM2_WIN, 0, 1, 1, 1)).to eq(0)
    expect(ctp_call_helper(subject::TEAM2_WIN, 0, 3, 1, 2)).to eq(3)

    expect(ctp_call_helper(subject::DRAW, 0, 0, 0, 0)).to eq(8)
    expect(ctp_call_helper(subject::DRAW, 0, 0, 1, 1)).to eq(4)
    expect(ctp_call_helper(subject::DRAW, 0, 0, 2, 1)).to eq(0)
    expect(ctp_call_helper(subject::DRAW, 0, 0, 1, 2)).to eq(0)
  end


  describe 'calculate all user tip points' do

    before :each do
      Game.destroy_all
      Tip.destroy_all
      User.destroy_all

      @game1 = create(:game, :team1_goals => 0, :team2_goals => 0)
      @game2 = create(:game, :team1_goals => 1, :team2_goals => 0)
      @game3 = create(:game, :team1_goals => 0, :team2_goals => 1)
      @game4 = create(:game, :team1_goals => 2, :team2_goals => 1)
      @game5 = create(:game, :team1_goals => 0, :team2_goals => 3)

      @user1 = create_active_user
      @user2 = create_active_user
      @user3 = create_active_user
      @user4 = create_active_user
      @user5 = create_active_user

      User.all.each do |user|
        Game.all.each do |game|
          create(:tip, :user => user, :game => game,
                 :team1_goals => rand(4), :team2_goals => rand(4))
        end
      end
    end

    it 'should update all tip points for a game' do
      expect(Tip.where(:game_id => @game1.id).size).to eq(5)
      where_sql = ["game_id = ? and tip_points is not null", @game1.id]
      tips = Tip.where(where_sql).to_a
      expect(tips).not_to be_present

      subject.new.send('update_all_tip_points_for', @game1)

      tips = Tip.where(where_sql).to_a
      expect(tips).to be_present
      tips.size == 5
    end

    it 'should update all tip points for all games' do
      where_sql = ["tip_points is not null"]
      expect(Tip.where(where_sql).count).to eq(0)

      subject.call

      # noch keine Tipp Punkte vergeben, da noch kein Spiel beendet
      expect(Tip.where(where_sql).count).to eq(0)

      Game.first.update_column(:finished, true)
      subject.call
      # Tipp Punkte fürs erste Spiel vergeben
      expect(Tip.where(where_sql).count).to eq(5)

      Game.update_all("finished=true")
      subject.call
      # alleTipp Punkte vergeben
      expect(Tip.where(["tip_points is null"]).count).to eq(0)
    end
  end

end