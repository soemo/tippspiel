require 'rails_helper'

describe TipsController, type: :controller do

  let!(:user) {create :active_user}
  let(:tips) {[Tip.new, Tip.new]}

  describe '#save_tips' do
    before :each do
      login(user)
    end

    it 'saves only tips for games start in the future' do
      user = User.last
      FactoryGirl.create(:game)

      tips = Tips::FromUser.call(:user_id => user.id)
      expect(tips.size).to be > 0

      tip = Tip.first
      game = tip.game

      Timecop.freeze(Time.now)
      game.update_column(:start_at, Time.now+1.second) #Spielstart in der Zukunft

      # update erlaubt
      post :save_tips, {:tips=>{"#{tip.id}"=>{'team1_goals' => '9', 'team2_goals' => '9'}}}
      expect(response).to redirect_to root_path

      t = Tip.find(tip.id)
      expect(t.team1_goals).to eq(9)
      expect(t.team2_goals).to eq(9)

      game.update_attribute(:start_at, Time.now) #Spiel startet genau jetzt

      # update NICHT erlaubt
      post :save_tips, {:tips=>{"#{tip.id}"=>{'team1_goals' => '0', 'team2_goals' => '3'}}}
      expect(response).to redirect_to root_path

      t = Tip.find(tip.id)
      expect(t.team1_goals).to eq(9) # Wert ist nicht veraendert
      expect(t.team2_goals).to eq(9) # Wert ist nicht veraendert
    end
  end

end
