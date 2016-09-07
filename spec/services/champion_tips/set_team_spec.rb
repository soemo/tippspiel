require 'rails_helper'

describe ChampionTips::SetTeam do

  subject { ChampionTips::SetTeam }

  let!(:user) {create :user}

  let(:championtip_team_id) {42}

  context 'if is before tournament ' do

    before :each do
      expect(Tournament).to receive(:not_yet_started?).and_return(true)
    end

    context 'and championtip_team_id' do

      it 'sets team as champion tip to the user' do
        subject.call(championtip_team_id: championtip_team_id, current_user: user)

        expect(user.championtip_team_id).to eq(championtip_team_id)
      end
    end

    context 'and championtip_team_id is not present' do

      it 'does not set team as champion tip to the user' do
        subject.call(championtip_team_id: nil, current_user: user)

        expect(user.championtip_team_id).to be nil
      end
    end
  end

  context 'if tournament is running' do

    before :each do
      expect(Tournament).to receive(:not_yet_started?).and_return(false)
    end

    context 'championtip_team_id' do

      it 'does not set team as champion tip to the user' do
        subject.call(championtip_team_id: championtip_team_id, current_user: user)

        expect(user.championtip_team_id).to be nil
      end
    end
  end
end