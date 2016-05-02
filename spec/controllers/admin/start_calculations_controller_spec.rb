require 'rails_helper'

describe Admin::StartCalculatingsController do

  let!(:no_admin_user) { create(:active_user) }
  let!(:admin_user) { create(:active_admin) }

  describe '#new' do

    context 'if current_user is an admin' do

      it 'starts calculations' do
        login(admin_user)
        expect(Tips::UpdatePoints).to receive(:call)
        expect(Users::UpdatePoints).to receive(:call)
        expect(Users::UpdateRankingPerGame).to receive(:call)

        get :new

        expect(response).to redirect_to admin_games_path
      end
    end

    context 'if current_user is not an admin' do

      it 'do not starts calculations' do
        login(no_admin_user)
        expect(Tips::UpdatePoints).not_to receive(:call)
        expect(Users::UpdatePoints).not_to receive(:call)
        expect(Users::UpdateRankingPerGame).not_to receive(:call)

        get :new

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end