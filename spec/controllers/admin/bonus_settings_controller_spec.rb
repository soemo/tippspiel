# frozen_string_literal: true

require 'rails_helper'

describe Admin::BonusSettingsController do
  let!(:no_admin_user) { create(:active_user) }
  let!(:admin_user)    { create(:active_admin) }

  describe '#new' do
    context 'if current_user is an admin' do
      it 'renders the bonus answer form' do
        login(admin_user)

        get :new

        expect(response).to have_http_status(:ok)
      end
    end

    context 'if current_user is not an admin' do
      it 'returns forbidden' do
        login(no_admin_user)

        get :new

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe '#create' do
    context 'if current_user is an admin' do
      it 'saves bonus answers and redirects back to the form' do
        login(admin_user)

        post :create, params: { bonus_how_many_goals: '7', bonus_when_final_first_goal: '2' }

        expect(AppSetting.bonus_answer_how_many_goals).to eq(7)
        expect(AppSetting.bonus_answer_when_will_the_first_goal).to eq(2)
        expect(response).to redirect_to new_admin_bonus_settings_path
      end

      it 'does not trigger point calculation' do
        login(admin_user)
        expect(Tips::UpdatePoints).not_to receive(:call)
        expect(Users::UpdatePoints).not_to receive(:call)
        expect(Users::UpdateRankingPerGame).not_to receive(:call)

        post :create, params: { bonus_how_many_goals: '7', bonus_when_final_first_goal: '2' }
      end
    end

    context 'if current_user is not an admin' do
      it 'does not save settings' do
        login(no_admin_user)

        post :create, params: { bonus_how_many_goals: '7', bonus_when_final_first_goal: '2' }

        expect(AppSetting.bonus_answer_how_many_goals).to be_nil
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
