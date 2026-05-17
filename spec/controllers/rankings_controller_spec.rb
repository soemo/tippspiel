# frozen_string_literal: true

require 'rails_helper'

describe RankingsController do
  describe 'GET "index" with login' do
    before do
      login(create(:active_user))
    end

    it 'is successful with login' do
      get 'index'
      expect(response).to be_successful
      presenter = assigns(:presenter)
      expect(presenter).to be_a(RankingPresenter)
      user_count = presenter.user_count
      expect(user_count).to eq(1)
    end
  end

  describe 'GET "index" without login' do
    it 'is redirected to root' do
      get 'index'
      expect(response).to redirect_to new_user_session_path
    end
  end
end
