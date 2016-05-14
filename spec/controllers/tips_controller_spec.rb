# -*- encoding : utf-8 -*-
require 'rails_helper'

describe TipsController, :type => :controller do

  let!(:user) {create :active_user}
  let(:tips) {[Tip.new, Tip.new]}

  describe '#index with login' do

    before :each do
      login(user)
    end

    it 'be successful with login' do
      expect(Tips::FromUser).to receive(:call).with(user_id: user.id).
          and_return(tips)
      get 'index'

      expect(assigns(:presenter)).to be_instance_of TipsIndexPresenter
      expect(assigns(:presenter).current_user).to eq user
      expect(assigns(:presenter).tips).to eq tips
      expect(response).to have_http_status(:success)
      expect(response).to render_template :index
    end

  end

  describe '#index without login' do

    it 'be redirected to root' do
      get 'index'
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe '#save_tips' do
    before :each do
      login(create :active_user)
    end

    it "should only save tips for games start in the future" do
      user = User.last
      FactoryGirl.create(:game)

      tips = Tips::FromUser.call(:user_id => user.id)
      expect(tips.size).to be > 0

      tip = Tip.first
      game = tip.game

      Timecop.freeze(Time.now)
      game.update_column(:start_at, Time.now+1.second) #Spielstart in der Zukunft

      # update erlaubt
      post 'save_tips', {:tips=>{"#{tip.id}"=>{"team2_goals"=>"9", "team1_goals"=>"9"}}}
      expect(response).to redirect_to tips_path

      t = Tip.find(tip.id)
      expect(t.team1_goals).to eq(9)
      expect(t.team2_goals).to eq(9)

      game.update_attribute(:start_at, Time.now) #Spiel startet genau jetzt

      # update NICHT erlaubt
      post 'save_tips', {:tips=>{"#{tip.id}"=>{"team2_goals"=>"3", "team1_goals"=>"0"}}}
      expect(response).to redirect_to tips_path

      t = Tip.find(tip.id)
      expect(t.team1_goals).to eq(9) # Wert ist nicht veraendert
      expect(t.team2_goals).to eq(9) # Wert ist nicht veraendert
    end
  end

end
