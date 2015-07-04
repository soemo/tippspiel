# -*- encoding : utf-8 -*-
require 'rails_helper'

describe TipsController, :type => :controller do

  describe "GET 'index' with login" do
     spec_login_user

    it "should be successful with login" do
      get 'index'
      expect(response).to be_success
    end

  end

  describe "GET 'index' without login" do

    it "should be redirected to root" do
      get 'index'
      expect(response).to redirect_to root_path
    end
  end

  describe "save_tips" do
    spec_login_user

    it "should only save tips for games start in the future" do
      user = User.find_by_email("user@test.de") #email des eingeloggten Nutzers
      FactoryGirl.create(:game)

      tips = Tips::FromUser.call(:user_id => user.id)
      expect(tips.size).to be > 0

      tip = Tip.first
      game = tip.game

      Timecop.freeze(Time.now)
      game.update_column(:start_at, Time.now+1.second) #Spielstart in der Zukunft

      # update erlaubt
      post 'save_tips', {:tips=>{"#{tip.id}"=>{"team2_goals"=>"9", "team1_goals"=>"9"}}}
      expect(response).to redirect_to tips_path({:for_phone=>false})

      t = Tip.find(tip.id)
      expect(t.team1_goals).to eq(9)
      expect(t.team2_goals).to eq(9)

      game.update_attribute(:start_at, Time.now) #Spiel startet genau jetzt

      # update NICHT erlaubt
      post 'save_tips', {:tips=>{"#{tip.id}"=>{"team2_goals"=>"3", "team1_goals"=>"0"}}}
      expect(response).to redirect_to tips_path({:for_phone=>false})

      t = Tip.find(tip.id)
      expect(t.team1_goals).to eq(9) # Wert ist nicht veraendert
      expect(t.team2_goals).to eq(9) # Wert ist nicht veraendert
    end
  end

end
