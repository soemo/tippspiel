require 'rails_helper'

describe BonusTipsController, type: :controller do
  let!(:user) {create :active_user}
  let!(:bonus_champion_team_id) {42}
  let!(:bonus_second_team_id) {1}
  let!(:bonus_when_final_first_goal) {2}
  let!(:bonus_how_many_goals) {9}

  describe '#update' do
    before :each do
      login(user)
    end

    context 'BonusTips::SaveAnswers result is true' do

      it 'redirects to root_path and shows flash notice' do
        expect(BonusTips::SaveAnswers).to receive(:call).
            with(bonus_champion_team_id: bonus_champion_team_id.to_s,
                 bonus_second_team_id: bonus_second_team_id.to_s,
                 bonus_when_final_first_goal: bonus_when_final_first_goal.to_s,
                 bonus_how_many_goals: bonus_how_many_goals.to_s,
                 current_user: user).
            and_return(true)

        patch :update, params: {
          bonus_champion_team_id: bonus_champion_team_id.to_s,
          bonus_second_team_id: bonus_second_team_id.to_s,
          bonus_when_final_first_goal: bonus_when_final_first_goal.to_s,
          bonus_how_many_goals: bonus_how_many_goals.to_s
        }

        expect(flash[:notice]).to eq(t(:succesfully_saved_bonustip))
        expect(response).to redirect_to edit_bonus_path
      end
    end

    context 'BonusTips::SaveAnswers result is false' do

      it 'redirects to root_path without any flash notice' do
        expect(BonusTips::SaveAnswers).to receive(:call).
            with(bonus_champion_team_id: bonus_champion_team_id.to_s,
                 bonus_second_team_id: bonus_second_team_id.to_s,
                 bonus_when_final_first_goal: bonus_when_final_first_goal.to_s,
                 bonus_how_many_goals: bonus_how_many_goals.to_s,
                 current_user: user).
            and_return(false)

        patch :update, params: {
          bonus_champion_team_id: bonus_champion_team_id.to_s,
          bonus_second_team_id: bonus_second_team_id.to_s,
          bonus_when_final_first_goal: bonus_when_final_first_goal.to_s,
          bonus_how_many_goals: bonus_how_many_goals.to_s
        }

        expect(flash[:notice]).to be nil
        expect(response).to redirect_to edit_bonus_path
      end
    end
   end
end
