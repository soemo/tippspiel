require 'rails_helper'

describe CompareTipsController do

  describe "GET #show" do

    it "returns http success" do
      login(create :active_user)
      get :show
      expect(response).to have_http_status(200)
    end
  end

end
