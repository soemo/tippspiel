require 'rails_helper'

describe CompareTipsController do


  describe "GET #show" do
    spec_login_user

    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

end
