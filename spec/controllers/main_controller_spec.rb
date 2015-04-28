# -*- encoding : utf-8 -*-
require 'rails_helper'

describe MainController, :type => :controller do

  context "#index" do
    it "should be successful" do
      get :index
      expect(response).to be_success
    end
  end

  context "#error" do
    it "shows extra text, if 500 error" do
      expect(controller).to receive(:flash) { {error: I18n.t(:error_internal) }}
      get :error
      expect(response).to be_success
      expect(assigns[:error_msg]).to eq({text: I18n.t(:error_500_text)})
    end

    it "shows no extra text" do
      expect(controller).to receive(:flash) { {error: 'other_error_text' }}
      get :error
      expect(response).to be_success
      expect(assigns[:error_msg]).to eq(nil)
    end
  end


end
