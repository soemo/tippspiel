# frozen_string_literal: true

require 'rails_helper'

describe Admin::StartCalculatingsController do
  let!(:no_admin_user) { create(:active_user) }
  let!(:admin_user)    { create(:active_admin) }

  describe '#new' do
    context 'if current_user is an admin' do
      it 'runs calculations and redirects to games' do
        login(admin_user)
        expect(Rankings::Recalculate).to receive(:call)

        get :new

        expect(response).to redirect_to admin_games_path
      end
    end

    context 'if current_user is not an admin' do
      it 'does not run calculations' do
        login(no_admin_user)
        expect(Rankings::Recalculate).not_to receive(:call)

        get :new

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
