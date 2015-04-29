require 'rails_helper'

describe TippQueries do

  subject { TippQueries }

  context '.get_ordered_tipps_for_game_id' do

    let!(:user1) {create(:user, firstname: 'ZZZ')}
    let!(:user2) {create(:user, firstname: 'AAA')}
    let!(:user3) {create(:user, firstname: 'BBB')}

    let!(:game1) { create(:game)}
    let!(:game2) { create(:game)}
    let!(:game3) { create(:game)}

    let!(:tipp_g1_u1) {create :tipp, game: game1, user: user1 }
    let!(:tipp_g1_u2) {create :tipp, game: game1, user: user2 }
    let!(:tipp_g1_u3) {create :tipp, game: game1, user: user3 }
    let!(:tipp_g2_u1) {create :tipp, game: game2, user: user1 }
    let!(:tipp_g2_u2) {create :tipp, game: game2, user: user2 }
    let!(:tipp_g2_u3) {create :tipp, game: game2, user: user3 }
    let!(:tipp_g3_u1) {create :tipp, game: game3, user: user1 }
    let!(:tipp_g3_u2) {create :tipp, game: game3, user: user2 }
    let!(:tipp_g3_u3) {create :tipp, game: game3, user: user3 }

    before :each do
      expect(Game.count).to eq(3)
      expect(User.count).to eq(3)
      expect(Tipp.count).to eq(9)
    end

    it 'returns empty Array if no game_id given' do
      tipps = subject.get_ordered_tipps_for_game_id(nil)
      expect(tipps).to eq ([])
    end

    context 'when game_id given' do
      it 'returns tipps ordered by user firstname' do
        tipps = subject.get_ordered_tipps_for_game_id(game1.id)
        expect(tipps.to_a).to eq([tipp_g1_u2, tipp_g1_u3, tipp_g1_u1])

        tipps = subject.get_ordered_tipps_for_game_id(game2.id)
        expect(tipps.to_a).to eq([tipp_g2_u2, tipp_g2_u3, tipp_g2_u1])

        tipps = subject.get_ordered_tipps_for_game_id(game3.id)
        expect(tipps.to_a).to eq([tipp_g3_u2, tipp_g3_u3, tipp_g3_u1])
      end

      it 'returns ordered tipps with tipp points' do
        tipp_g1_u1.update_column(:tipp_punkte, 8)
        tipps = subject.get_ordered_tipps_for_game_id(game1.id)
        expect(tipps.to_a).to eq([tipp_g1_u1, tipp_g1_u2, tipp_g1_u3])

        tipp_g1_u3.update_column(:tipp_punkte, 1)
        tipps = subject.get_ordered_tipps_for_game_id(game1.id)
        expect(tipps.to_a).to eq([tipp_g1_u1, tipp_g1_u3, tipp_g1_u2])

      end

      it 'returns ordered tipps for existing users' do
        user1.destroy

        tipps = subject.get_ordered_tipps_for_game_id(game1.id)
        expect(tipps.to_a).to eq([tipp_g1_u2, tipp_g1_u3])
      end
    end


  end


end