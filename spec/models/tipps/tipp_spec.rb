# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Tipp, :type => :model do

  it "should use Factory" do
      tipp = FactoryGirl.build(:tipp)
      expect(tipp.game).to be_present
      expect(tipp.user).to be_present
  end

  describe 'User Tipps' do

    it 'gets all user tipps' do
      5.times{create(:game)}

      games = Game.all
      user = create(:user)
      games_size = games.size

      user_tipp_count = Tipp.where("user_id" => user.id).count
      expect(user_tipp_count).to eq(0)

      user_tipps = GetUserTipps.call(:user_id => user.id)
      expect(user_tipps.size).to eq(games_size)
      expect(user_tipps.pluck(:game_id)).to eq(games.pluck(:id))
    end

  end

  describe "tipp edit allowed" do
    before do
      user = create(:user)
      FactoryGirl.create(:game)
      @user_tipps = GetUserTipps.call(:user_id => user.id)
    end

    it "should allowed" do
      first_tipp = @user_tipps.first
      game = first_tipp.game
      game.update_column(:start_at, Time.now + 1.minute)
      expect(first_tipp.edit_allowed?).to be true
    end

    it "should not allowed" do
      first_tipp = @user_tipps.first
      game = first_tipp.game
      game.update_column(:start_at, Time.now)
      expect(first_tipp.edit_allowed?).to be false
    end

  end

  describe "tipp remove leading zero" do
    it "should a remove leading zero" do
      t = Tipp.new({:team1_goals => 00, :team2_goals => 02})
      t.remove_leading_zero
      expect(t.team1_goals).to eq(0)
      expect(t.team2_goals).to eq(2)

      t = Tipp.new({:team1_goals => 10, :team2_goals => 11})
      t.remove_leading_zero
      expect(t.team1_goals).to eq(10)
      expect(t.team2_goals).to eq(11)
    end
  end


end
