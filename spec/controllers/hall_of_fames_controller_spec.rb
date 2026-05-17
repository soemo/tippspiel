# frozen_string_literal: true

require 'rails_helper'

describe HallOfFamesController do
  describe '#show with login' do
    it 'be successful' do
      login(create(:active_user))
      get :show
      expect(response).to be_successful
    end
  end

  describe '#show without login' do
    it 'be redirected to root' do
      get :show
      expect(response).to redirect_to new_user_session_path
    end
  end
end
