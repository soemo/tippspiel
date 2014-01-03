# -*- encoding : utf-8 -*-
require 'spec_helper'

describe RankingController do

  describe 'GET "index" with login' do
     spec_login_user

    it 'should be successful with login' do
      get 'index'
      response.should be_success
      user_count = assigns(:user_count)
      user_ranking_hash = assigns(:user_ranking_hash)

      user_count.should == 3 # 3 in den Fixtures
      user_ranking_hash.has_key?(1).should be_present     # alle 3 auf dem ersten Platz
      user_ranking_hash.has_key?(2).should_not be_present # keiner auf dem 2ten Platz
    end

  end

  describe 'GET "index" without login' do

    it 'should be redirected to root' do
      get 'index'
      response.should redirect_to root_path
    end
  end
end
