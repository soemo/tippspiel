require 'rails_helper'

describe RankingsController, :type => :controller do

  describe 'GET "index" with login' do
    before :each do
      login(create :active_user)
    end

    it 'should be successful with login' do
      get 'index'
      expect(response).to be_successful
      presenter = assigns(:presenter)
      expect(presenter).to be_a(RankingPresenter)
      user_count = presenter.user_count
      expect(user_count).to eq(1)
    end

  end

  describe 'GET "index" without login' do

    it 'should be redirected to root' do
      get 'index'
      expect(response).to redirect_to new_user_session_path
    end
  end
end
