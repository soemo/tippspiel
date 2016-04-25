# -*- encoding : utf-8 -*-
require 'rails_helper'

describe RankingController, :type => :controller do

  describe 'GET "index" with login' do
     spec_login_user

    it 'should be successful with login' do
      get 'index'
      expect(response).to be_success
      presenter = assigns(:presenter)
      expect(presenter).to be_a(RankingPresenter)
      user_count = presenter.user_count
      expect(user_count).to eq(1)
    end

  end

  describe 'GET "index" without login' do

    it 'should be redirected to root' do
      get 'index'
      expect(response).to redirect_to root_path
    end
  end
end
