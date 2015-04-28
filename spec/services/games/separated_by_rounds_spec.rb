require 'rails_helper'

describe Games::SeparatedByRounds do

  subject { Games::SeparatedByRounds }

  let!(:game1_group_a) { create(:game, round: Game::GROUP, group: Game::GROUP_A)}
  let!(:game2_group_a) { create(:game, round: Game::GROUP, group: Game::GROUP_A)}

  let!(:game1_group_b) { create(:game, round: Game::GROUP, group: Game::GROUP_B)}
  let!(:game2_group_b) { create(:game, round: Game::GROUP, group: Game::GROUP_B)}

  let!(:game1_group_c) { create(:game, round: Game::GROUP, group: Game::GROUP_C)}
  let!(:game2_group_c) { create(:game, round: Game::GROUP, group: Game::GROUP_C)}

  # no games for group d - h  (groups e - h only if WM)
  # no games for round of 16 (only WM)

  let!(:game1_quarter) { create(:game, round: Game::QUARTERFINAL, group: nil)}
  let!(:game2_quarter) { create(:game, round: Game::QUARTERFINAL, group: nil)}

  let!(:game1_sf) { create(:game, round: Game::SEMIFINAL, group: nil)}
  let!(:game2_sf) { create(:game, round: Game::SEMIFINAL, group: nil)}

  # no game for place 3 (only WM)

  let!(:game_f) { create(:game, round: Game::FINAL, group: nil)}


  it 'returns games seperated by rounds' do
    expect(Game.count).to eq(11)

    if IS_WM
      expected = [
          [1, {'group_a' => [game1_group_a, game2_group_a]}],
          [2, {'group_b' => [game1_group_b, game2_group_b]}],
          [3, {'group_c' => [game1_group_c, game2_group_c]}],
          [4, {'group_d' => []}],
          [5, {'group_e' => []}],
          [6, {'group_f' => []}],
          [7, {'group_g' => []}],
          [8, {'group_h' => []}],
          [9, {'roundof16' => []}],
          [10, {'quarterfinal' => [game1_quarter, game2_quarter]}],
          [11, {'semifinal' => [game1_sf, game2_sf]}],
          [12, {'place3' => []}],
          [13, {'final' => [game_f]}]
      ]
    elsif IS_EM
      expected = [
          [1, {'group_a' => [game1_group_a, game2_group_a]}],
          [2, {'group_b' => [game1_group_b, game2_group_b]}],
          [3, {'group_c' => [game1_group_c, game2_group_c]}],
          [4, {'group_d' => []}],
          [5, {'quarterfinal' => [game1_quarter, game2_quarter]}],
          [6, {'semifinal' => [game1_sf, game2_sf]}],
          [7, {'final' => [game_f]}]
      ]
    end


    expect(subject.call).to eq(expected)
  end

end