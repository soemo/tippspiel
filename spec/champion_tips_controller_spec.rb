require 'rails_helper'

describe ChampionTipsController, type: :controller do

  let!(:user) {create :active_user}
  let!(:championtip_team_id) {42}

  describe '#update' do
    before :each do
      login(user)
    end

    context 'ChampionTips::SetTeam result is true' do

      it 'redirects to root_path and shows flash notice' do
        expect(ChampionTips::SetTeam).to receive(:call).
            with(championtip_team_id: championtip_team_id.to_s, current_user: user).
            and_return(true)

        patch :update, {championtip_team_id: championtip_team_id.to_s}

        expect(flash[:notice]).to eq(t(:succesfully_saved_championtip))
        expect(response).to redirect_to root_path
      end
    end

    context 'ChampionTips::SetTeam result is false' do

      it 'redirects to root_path without any flash notice' do
        expect(ChampionTips::SetTeam).to receive(:call).
            with(championtip_team_id: championtip_team_id.to_s, current_user: user).
            and_return(false)

        patch :update, {championtip_team_id: championtip_team_id.to_s}

        expect(flash[:notice]).to be nil
        expect(response).to redirect_to root_path
      end
    end
   end
end
