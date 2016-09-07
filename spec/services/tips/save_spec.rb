require 'rails_helper'

describe Tips::Save do

  subject { Tips::Save }

  let!(:user) {create :user}

  let!(:game1) {create :game, start_at: Time.now + 1.day, finished: true}
  let!(:game2) {create :game, start_at: Time.now + 1.day, finished: true}
  let!(:game3) {create :game, start_at: Time.now - 1.day, finished: true}

  let!(:tip_g1) {create(:tip, user: user, game: game1, team1_goals: nil, team2_goals: nil)}
  let!(:tip_g2) {create(:tip, user: user, game: game2, team1_goals: nil, team2_goals: nil)}
  let!(:tip_g3) {create(:tip, user: user, game: game3, team1_goals: nil, team2_goals: nil)}

  let!(:tip_params) {
    create_params_hash({
                           "#{tip_g1.id}" => {
                               team1_goals: '0',
                               team2_goals: '1',
                           },
                           "#{tip_g2.id}" => {
                               team1_goals: '02',  #test with leading zero
                               team2_goals: '3',
                           },
                           "#{tip_g3.id}" => {
                               team1_goals: '4',
                               team2_goals: '5',
                           }
                       })
  }

  context 'if tip_params and user present?' do

    it 'saves tips' do

      subject.call(current_user: user, tips_params: tip_params)

      tip1= Tip.find(tip_g1.id)
      tip2= Tip.find(tip_g2.id)
      tip3= Tip.find(tip_g3.id)
      expect(tip1.team1_goals).to eq(0)
      expect(tip1.team2_goals).to eq(1)
      expect(tip2.team1_goals).to eq(2)
      expect(tip2.team2_goals).to eq(3)
      expect(tip3.team1_goals).to eq(nil) # dieser Tipp duerfte nicht mehr abgegeben werden
      expect(tip3.team2_goals).to eq(nil) # dieser Tipp duerfte nicht mehr abgegeben werden

    end
  end

  context 'if tip_params and user not present?' do

    it 'saves no tips' do
      expect(Tips::FromUser).to_not receive(:call)
      subject.call(current_user: nil, tips_params: nil)
    end
  end

end