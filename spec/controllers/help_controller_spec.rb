# -*- encoding : utf-8 -*-
require 'rails_helper'

describe HelpController, :type => :controller do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      expect(response).to be_success
    end
  end

end
