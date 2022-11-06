require 'rails_helper'

describe BonusTips::SaveAnswers do

  subject { BonusTips::SaveAnswers }

  let!(:user) {create :user}

  let(:bonus_champion_team_id) {42}
  let(:bonus_second_team_id) {42}

  context 'if is before tournament ROUND_OF_16' do

    before :each do
      expect(Tournament).to receive(:round_of_16_not_yet_started?).and_return(true)
    end

    it 'sets values as tips to the user' do
      subject.call(bonus_champion_team_id: bonus_champion_team_id,
                   bonus_second_team_id: bonus_second_team_id,
                   current_user: user)
      expect(user.bonus_champion_team_id).to eq(bonus_champion_team_id)
      expect(user.bonus_second_team_id).to eq(bonus_second_team_id)
    end
  end

  context 'if tournament ROUND_OF_16 is running' do

    before :each do
      expect(Tournament).to receive(:round_of_16_not_yet_started?).and_return(false)
    end

    it 'does not set bonus tip values to the user' do
      subject.call(
        bonus_champion_team_id: bonus_champion_team_id,
        bonus_second_team_id: bonus_second_team_id,
        current_user: user)

      expect(user.bonus_champion_team_id).to be nil
      expect(user.bonus_second_team_id).to be nil
    end
  end
end