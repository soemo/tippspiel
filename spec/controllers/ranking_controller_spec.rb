# -*- encoding : utf-8 -*-
require 'rails_helper'

describe RankingController, :type => :controller do

  describe 'GET "index" with login' do
     spec_login_user

    it 'should be successful with login' do
      get 'index'
      expect(response).to be_success
      user_count = assigns(:user_count)
      user_ranking_hash = assigns(:user_ranking_hash)

      expect(user_count).to eq(3) # 3 in den Fixtures
      expect(user_ranking_hash.has_key?(1)).to be_present     # alle 3 auf dem ersten Platz
      expect(user_ranking_hash.has_key?(2)).not_to be_present # keiner auf dem 2ten Platz
    end

  end

  describe 'GET "index" without login' do

    it 'should be redirected to root' do
      get 'index'
      expect(response).to redirect_to root_path
    end
  end
end
