require 'rails_helper'

describe TipQueries do

  subject { TipQueries }

  context ':all_ordered_by_tip_points_and_user_firstname_by_game_id' do

    let!(:user1) {create(:user, firstname: 'ZZZ')}
    let!(:user2) {create(:user, firstname: 'AAA')}
    let!(:user3) {create(:user, firstname: 'BBB')}

    let!(:game1) { create(:game)}
    let!(:game2) { create(:game)}
    let!(:game3) { create(:game)}

    let!(:tip_g1_u1) {create :tip, game: game1, user: user1 }
    let!(:tip_g1_u2) {create :tip, game: game1, user: user2 }
    let!(:tip_g1_u3) {create :tip, game: game1, user: user3 }
    let!(:tip_g2_u1) {create :tip, game: game2, user: user1 }
    let!(:tip_g2_u2) {create :tip, game: game2, user: user2 }
    let!(:tip_g2_u3) {create :tip, game: game2, user: user3 }
    let!(:tip_g3_u1) {create :tip, game: game3, user: user1 }
    let!(:tip_g3_u2) {create :tip, game: game3, user: user2 }
    let!(:tip_g3_u3) {create :tip, game: game3, user: user3 }

    before :each do
      expect(Game.count).to eq(3)
      expect(User.count).to eq(3)
      expect(Tip.count).to eq(9)
    end

    it 'returns empty Array if no game_id given' do
      tips = subject.all_ordered_by_tip_points_and_user_firstname_by_game_id(nil)
      expect(tips).to eq ([])
    end

    context 'when game_id given' do
      it 'returns tips ordered by user firstname' do
        tips = subject.all_ordered_by_tip_points_and_user_firstname_by_game_id(game1.id)
        expect(tips.to_a).to eq([tip_g1_u2, tip_g1_u3, tip_g1_u1])

        tips = subject.all_ordered_by_tip_points_and_user_firstname_by_game_id(game2.id)
        expect(tips.to_a).to eq([tip_g2_u2, tip_g2_u3, tip_g2_u1])

        tips = subject.all_ordered_by_tip_points_and_user_firstname_by_game_id(game3.id)
        expect(tips.to_a).to eq([tip_g3_u2, tip_g3_u3, tip_g3_u1])
      end

      it 'returns ordered tips with tip points' do
        tip_g1_u1.update_column(:tip_points, 8)
        tips = subject.all_ordered_by_tip_points_and_user_firstname_by_game_id(game1.id)
        expect(tips.to_a).to eq([tip_g1_u1, tip_g1_u2, tip_g1_u3])

        tip_g1_u3.update_column(:tip_points, 1)
        tips = subject.all_ordered_by_tip_points_and_user_firstname_by_game_id(game1.id)
        expect(tips.to_a).to eq([tip_g1_u1, tip_g1_u3, tip_g1_u2])

      end

      it 'returns ordered tips for existing users' do
        user1.destroy

        tips = subject.all_ordered_by_tip_points_and_user_firstname_by_game_id(game1.id)
        expect(tips.to_a).to eq([tip_g1_u2, tip_g1_u3])
      end
    end


  end


end