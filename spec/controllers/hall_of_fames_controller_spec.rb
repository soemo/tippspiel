# -*- encoding : utf-8 -*-
require 'rails_helper'

describe HallOfFamesController, :type => :controller do

  context  '#show with login' do

    it 'be successful' do
      login(create :active_user)
      get :show
      expect(response).to be_success
    end
  end

  context '#show without login' do

    it 'be redirected to root' do
      get :show
      expect(response).to redirect_to root_path
    end
  end
end
