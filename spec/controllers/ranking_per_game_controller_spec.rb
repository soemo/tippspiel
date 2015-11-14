require 'rails_helper'

RSpec.describe RankingPerGameController do
  spec_login_user
                         # FIXME soeren 21.07.15 #98
  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

end
