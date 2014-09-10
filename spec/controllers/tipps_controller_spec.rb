# -*- encoding : utf-8 -*-
require 'rails_helper'

describe TippsController, :type => :controller do

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

  describe "save_tipps" do
    spec_login_user

    it "should only save tipps for games start in the future" do
      user = User.find_by_email("user@test.de") #email des eingeloggten Nutzers
      FactoryGirl.create(:game)

      tipps = Tipp.user_tipps(user.id)
      expect(tipps.size).to be > 0

      tipp = Tipp.first
      game = tipp.game

      freeze_test_time
      game.update_attribute(:start_at, Time.now+1.second) #Spielstart in der Zukunft

      # update erlaubt
      post 'save_tipps', {:tipps=>{"#{tipp.id}"=>{"team2_goals"=>"9", "team1_goals"=>"9"}}}
      expect(response).to redirect_to tipps_path({:for_phone=>false})

      t = Tipp.find(tipp.id)
      expect(t.team1_goals).to eq(9)
      expect(t.team2_goals).to eq(9)

      game.update_attribute(:start_at, Time.now) #Spiel startet genau jetzt

      # update NICHT erlaubt
      post 'save_tipps', {:tipps=>{"#{tipp.id}"=>{"team2_goals"=>"3", "team1_goals"=>"0"}}}
      expect(response).to redirect_to tipps_path({:for_phone=>false})

      t = Tipp.find(tipp.id)
      expect(t.team1_goals).to eq(9) # Wert ist nicht veraendert
      expect(t.team2_goals).to eq(9) # Wert ist nicht veraendert
    end
  end

end
