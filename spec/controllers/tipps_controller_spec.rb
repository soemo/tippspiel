require 'spec_helper'

describe TippsController do

  describe "GET 'index' with login" do
     spec_login_user

    it "should be successful with login" do
      get 'index'
      response.should be_success
    end

  end

  describe "GET 'index' without login" do

    it "should be redirected to root" do
      get 'index'
      response.should redirect_to root_path
    end
  end

end
