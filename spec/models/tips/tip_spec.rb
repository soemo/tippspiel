# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Tip, :type => :model do

  it "should use Factory" do
      tip = FactoryGirl.build(:tip)
      expect(tip.game).to be_present
      expect(tip.user).to be_present
  end

  describe 'User Tips' do

    it 'gets all user tips' do
      5.times{create(:game)}

      games = Game.all
      user = create(:user)
      games_size = games.size

      user_tip_count = Tip.where(user_id: user.id).count
      expect(user_tip_count).to eq(0)

      user_tips = Tips::FromUser.call(:user_id => user.id)
      expect(user_tips.size).to eq(games_size)
      expect(user_tips.pluck(:game_id).sort).to eq(games.pluck(:id).sort)
    end

  end

  describe '#edit allowed' do

    let!(:game) {Game.new}
    let!(:tip) {Tip.new(game: game)}

    context 'if game is started' do

      it 'returns false' do
        expect(game).to receive(:started?).and_return(true)
        expect(tip.edit_allowed?).to be false
      end
    end

    context 'if game is not started' do

      it 'returns true' do
        expect(game).to receive(:started?).and_return(false)
        expect(tip.edit_allowed?).to be true
      end
    end
  end

  describe "tip remove leading zero" do
    it "should a remove leading zero" do
      t = Tip.new({:team1_goals => 00, :team2_goals => 02})
      t.remove_leading_zero
      expect(t.team1_goals).to eq(0)
      expect(t.team2_goals).to eq(2)

      t = Tip.new({:team1_goals => 10, :team2_goals => 11})
      t.remove_leading_zero
      expect(t.team1_goals).to eq(10)
      expect(t.team2_goals).to eq(11)
    end
  end


end
