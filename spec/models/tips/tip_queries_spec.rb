require 'rails_helper'

describe TipQueries do

  subject { TipQueries }

  let!(:user1) {create(:user, firstname: 'ZZZ')}
  let!(:user2) {create(:user, firstname: 'AAA')}
  let!(:user3) {create(:user, firstname: 'BBB')}
  let!(:user_with_no_tips) {create(:user)}

  let!(:game1) { create(:game, start_at: Time.now + 10.days)}
  let!(:game2) { create(:game, start_at: Time.now + 8.days)}
  let!(:game3) { create(:game, start_at: Time.now + 6.days)}

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
    expect(User.count).to eq(4)
    expect(Tip.count).to eq(9)
  end

  describe '::all_ordered_by_tip_points_and_user_firstname_by_game_id' do

    it 'returns empty Array if no game_id given' do
      tips = subject.all_ordered_by_tip_points_and_user_firstname_by_game_id(nil)
      expect(tips).to eq ([])
    end

    context 'if game_id given' do
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

  describe '::all_by_game_id' do

    it 'returns tips for game' do
      expect(subject.all_by_game_id(game1.id)).to eq([tip_g1_u1, tip_g1_u2, tip_g1_u3])
    end
  end

  describe '::all_by_game_ids_and_tip_points' do

    it 'returns tips for game and given tip points' do
      tip_g1_u2.update_column(:tip_points,  8)
      expect(subject.all_by_game_ids_and_tip_points(game1.id, 8)).to eq([tip_g1_u2])
    end
  end

  describe '::all_by_user_id_ordered_games_start_at_with_preloaded_games' do

    it 'returns tips for user' do
      expect(subject.all_by_user_id_ordered_games_start_at(user2.id)).to eq([
                                                                                tip_g3_u2,
                                                                                tip_g2_u2,
                                                                                tip_g1_u2
                                                                            ])
    end
  end

  describe '::all_by_user_id_and_tip_points' do

    it 'returns tips for user and given tip points' do
      tip_g1_u2.update_column(:tip_points,  8)
      expect(subject.all_by_user_id_and_tip_points(user2.id, 8)).to eq([tip_g1_u2])
      expect(subject.all_by_user_id_and_tip_points(user2.id, 6)).to eq([])
    end
  end

  describe '::exists_for_user_id' do

    context 'if tips exist for user_id' do
      it 'returns true' do
        expect(subject.exists_for_user_id(user2.id)).to be true
      end
    end

    context 'if no tips exist for user_id' do
      it 'returns true' do
        expect(subject.exists_for_user_id(user_with_no_tips.id)).to be false
      end
    end
  end

  describe '::sum_tip_points_by_user_id' do

    it 'returns sum tip points for user id' do
      tip_g1_u1.update_column(:tip_points,  8)
      tip_g2_u1.update_column(:tip_points,  5)
      tip_g3_u1.update_column(:tip_points,  8)
      expect(subject.sum_tip_points_by_user_id(user1.id)).to eq(21)
    end
  end

  describe '::sum_tip_points_group_by_user_id_by_game_ids' do

    it 'returns sum tip points for game ids grouped by user id' do
      tip_g1_u1.update_column(:tip_points,  8)
      tip_g1_u2.update_column(:tip_points,  5)
      tip_g1_u3.update_column(:tip_points,  0)

      tip_g2_u1.update_column(:tip_points,  3)
      tip_g2_u2.update_column(:tip_points,  5)
      tip_g2_u3.update_column(:tip_points,  8)
      expect(subject.sum_tip_points_group_by_user_id_by_game_ids([game1.id, game2.id])).to eq({
                                                                                                  user1.id => 11,
                                                                                                  user2.id => 10,
                                                                                                  user3.id => 8,
                                                                                              })
    end
  end
end