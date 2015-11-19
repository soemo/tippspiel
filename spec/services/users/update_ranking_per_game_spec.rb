# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Users::UpdateRankingPerGame do

  subject { Users::UpdateRankingPerGame }

  let!(:game1) {create :game, finished: true}
  let!(:game2) {create :game, finished: true}
  let!(:game3) {create :game, finished: true}

  let!(:user1) {create :user}
  let!(:user2) {create :user}
  let!(:user3) {create :user}
  let!(:user4) {create :user}

  let!(:tip_g1_u1) {create(:tip, user: user1, game: game1, tip_points: 8)}
  let!(:tip_g2_u1) {create(:tip, user: user1, game: game2, tip_points: 0)}
  let!(:tip_g3_u1) {create(:tip, user: user1, game: game3, tip_points: 3)}

  let!(:tip_g1_u2) {create(:tip, user: user2, game: game1, tip_points: 3)}
  let!(:tip_g2_u2) {create(:tip, user: user2, game: game2, tip_points: 4)}
  let!(:tip_g3_u2) {create(:tip, user: user2, game: game3, tip_points: 3)}

  let!(:tip_g1_u3) {create(:tip, user: user3, game: game1, tip_points: 3)}
  let!(:tip_g2_u3) {create(:tip, user: user3, game: game2, tip_points: 4)}
  let!(:tip_g3_u3) {create(:tip, user: user3, game: game3, tip_points: 3)}

  let!(:tip_g1_u4) {create(:tip, user: user4, game: game1, tip_points: 0)}
  let!(:tip_g2_u4) {create(:tip, user: user4, game: game2, tip_points: 8)}
  let!(:tip_g3_u4) {create(:tip, user: user4, game: game3, tip_points: 8)}

  it 'writes ranking_places to tips (per mass update)' do
    finished_game_ids = [game1.id, game2.id, game3.id]
    all_8point_tips = [tip_g1_u1, tip_g2_u4, tip_g3_u4]
    all_5point_tips = []
    all_4point_tips = [tip_g2_u2, tip_g2_u3]
    all_3point_tips = [tip_g3_u1, tip_g1_u2, tip_g3_u2, tip_g1_u3, tip_g3_u3]

    expect(GameQueries).to receive_message_chain(:all_finished_ordered_by_start_at, :pluck).
                               and_return(finished_game_ids)
    expect(TipQueries).to receive(:all_by_game_ids_and_tip_points).with(finished_game_ids, 8).
                              and_return(all_8point_tips)
    expect(TipQueries).to receive(:all_by_game_ids_and_tip_points).with(finished_game_ids, 5).
                              and_return(all_5point_tips)
    expect(TipQueries).to receive(:all_by_game_ids_and_tip_points).with(finished_game_ids, 4).
                              and_return(all_4point_tips)
    expect(TipQueries).to receive(:all_by_game_ids_and_tip_points).with(finished_game_ids, 3).
                              and_return(all_3point_tips)


    subject.call

    expect(Tip.find(tip_g1_u1.id).ranking_place).to eq(1)
    expect(Tip.find(tip_g1_u2.id).ranking_place).to eq(2)
    expect(Tip.find(tip_g1_u3.id).ranking_place).to eq(2)
    expect(Tip.find(tip_g1_u4.id).ranking_place).to eq(4)

    expect(Tip.find(tip_g2_u1.id).ranking_place).to eq(1)
    expect(Tip.find(tip_g2_u2.id).ranking_place).to eq(3)
    expect(Tip.find(tip_g2_u3.id).ranking_place).to eq(3)
    expect(Tip.find(tip_g2_u4.id).ranking_place).to eq(1)

    expect(Tip.find(tip_g3_u1.id).ranking_place).to eq(2)
    expect(Tip.find(tip_g3_u2.id).ranking_place).to eq(3)
    expect(Tip.find(tip_g3_u3.id).ranking_place).to eq(3)
    expect(Tip.find(tip_g3_u4.id).ranking_place).to eq(1)

  end

end