# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Tipp, :type => :model do

  it "should use Factory" do
      tipp = FactoryGirl.create(:tipp)
      expect(tipp.game).to be_present
      expect(tipp.user).to be_present
  end

  describe 'User Tipps' do

    it 'should get all user tipps' do
      user = users(:another_user)
      games = Game.all
      games_size = games.size

      user_tipps = Tipp.where("user_id" => user.id)
      expect(user_tipps).to eq([])

      user_tipps = Tipp.user_tipps(user.id)
      expect(user_tipps.size).to eq(games_size)
    end

  end

  describe "tipp edit allowed" do
    before do
      user = User.first
      FactoryGirl.create(:game)
      @user_tipps = Tipp.user_tipps(user.id)
    end

    it "should allowed" do
      first_tipp = @user_tipps.first
      game = first_tipp.game
      game.update_attribute(:start_at, Time.now + 1.minute)
      expect(first_tipp.edit_allowed?).to be_truthy
    end

    it "should not allowed" do
      first_tipp = @user_tipps.first
      game = first_tipp.game
      game.update_attribute(:start_at, Time.now)
      expect(first_tipp.edit_allowed?).to be_falsey
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
