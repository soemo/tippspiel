# -*- encoding : utf-8 -*-
require 'rails_helper'

describe MainController, :type => :controller do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      expect(response).to be_success
    end
  end

end
