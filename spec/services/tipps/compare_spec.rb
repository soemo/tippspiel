require 'rails_helper'

describe Tipps::Compare do

  subject { Tipps::Compare }

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
    Timecop.freeze(Time.now)
    game1.update_column(:start_at, Time.now - 1.minute)
    game2.update_column(:start_at, Time.now + 1.minute)
    game3.update_column(:start_at, Time.now + 1.day)

    expect(Game.count).to eq(3)
    expect(User.count).to eq(3)
    expect(Tipp.count).to eq(9)
  end


  it 'returns possible_games, game_to_compare and tips to show' do
    result = subject.call(game_id: game1.id)
    expect(result.possible_games).to eq([game1])
    expect(result.game_to_compare).to eq(game1)
    expect(result.tipps).to eq([tipp_g1_u2, tipp_g1_u3, tipp_g1_u1])
  end

  it 'returns last possible game, if game_id not given' do
    game2.update_column(:start_at, Time.now - 1.second)
    result = subject.call(game_id: nil)
    expect(result.possible_games).to eq([game1, game2])
    expect(result.game_to_compare).to eq(game2)
    expect(result.tipps).to eq([tipp_g2_u2, tipp_g2_u3, tipp_g2_u1])
  end

  it 'returns no possible game, game_to_compare and no tips' do
    # no game is started
    game1.update_column(:start_at, Time.now + 1.day)

    result = subject.call(game_id: nil)
    expect(result.possible_games).to eq([])
    expect(result.game_to_compare).to eq(nil)
    expect(result.tipps).to eq(nil)
  end

end