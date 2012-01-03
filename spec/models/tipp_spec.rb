require 'spec_helper'

describe Tipp do

  describe 'User Tipps' do

    it 'should get all user tipps' do
      user = users(:another_user)
      games = Game.all
      games_size = games.size

      user_tipps = Tipp.where("user_id" => user.id)
      user_tipps.should == []

      user_tipps = Tipp.user_tipps(user.id)
      user_tipps.size.should == games_size
    end

  end

  describe "tipp edit allowed" do
    before do
      user = User.first
      @user_tipps = Tipp.user_tipps(user.id)
    end

    it "should allowed" do
      first_tipp = @user_tipps.first
      game = first_tipp.game
      game.update_attribute(:start_at, Time.now + 1.minute)
      first_tipp.edit_allowed.should be_true
    end

    it "should not allowed" do
      first_tipp = @user_tipps.first
      game = first_tipp.game
      game.update_attribute(:start_at, Time.now)
      first_tipp.edit_allowed.should be_false
    end

  end

  describe "tipp remove leading zero" do
    it "should a remove leading zero" do
      t = Tipp.new({:team1_tore => 00, :team2_tore => 02})
      t.remove_leading_zero
      t.team1_tore.should == 0
      t.team2_tore.should == 2

    end
  end


end
