# frozen_string_literal: true

require 'rails_helper'

describe Tips::Compare do
  subject { described_class }

  let!(:user1) { create(:user, firstname: 'ZZZ') }
  let!(:user2) { create(:user, firstname: 'AAA') }
  let!(:user3) { create(:user, firstname: 'BBB') }

  let!(:game1) { create(:game) }
  let!(:game2) { create(:game) }
  let!(:game3) { create(:game) }

  let!(:tip_g1_u1) { create(:tip, game: game1, user: user1) }
  let!(:tip_g1_u2) { create(:tip, game: game1, user: user2) }
  let!(:tip_g1_u3) { create(:tip, game: game1, user: user3) }
  let!(:tip_g2_u1) { create(:tip, game: game2, user: user1) }
  let!(:tip_g2_u2) { create(:tip, game: game2, user: user2) }
  let!(:tip_g2_u3) { create(:tip, game: game2, user: user3) }
  let!(:tip_g3_u1) { create(:tip, game: game3, user: user1) }
  let!(:tip_g3_u2) { create(:tip, game: game3, user: user2) }
  let!(:tip_g3_u3) { create(:tip, game: game3, user: user3) }

  before do
    Timecop.freeze(Time.zone.now)
    game1.update_column(:start_at, 1.minute.ago)
    game2.update_column(:start_at, 1.minute.from_now)
    game3.update_column(:start_at, 1.day.from_now)

    expect(Game.count).to eq(3)
    expect(User.count).to eq(3)
    expect(Tip.count).to eq(9)
  end

  it 'returns possible_games, game_to_compare and tips to show' do
    result = subject.call(game_id: game1.id)
    expect(result.possible_games).to eq([game1])
    expect(result.game_to_compare).to eq(game1)
    expect(result.tips).to eq([tip_g1_u2, tip_g1_u3, tip_g1_u1])
  end

  it 'returns last possible game, if game_id not given' do
    game2.update_column(:start_at, 1.second.ago)
    result = subject.call(game_id: nil)
    expect(result.possible_games).to eq([game1, game2])
    expect(result.game_to_compare).to eq(game2)
    expect(result.tips).to eq([tip_g2_u2, tip_g2_u3, tip_g2_u1])
  end

  it 'returns no possible game, game_to_compare and no tips' do
    # no game is started
    game1.update_column(:start_at, 1.day.from_now)

    result = subject.call(game_id: nil)
    expect(result.possible_games).to eq([])
    expect(result.game_to_compare).to be_nil
    expect(result.tips).to be_nil
  end
end
