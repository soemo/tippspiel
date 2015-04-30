require 'rails_helper'

describe GameQueries do

  subject { GameQueries }

  context '.first_game_in_tournament' do

    it 'returns first game' do
      Timecop.freeze(Time.now)
      game1 = create(:game, start_at: Time.now - 1.day)
      game2 = create(:game, start_at: Time.now - 5.days)
      game3 = create(:game, start_at: Time.now + 1.day)

      game = subject.first_game_in_tournament
      expect(game).to eq(game2)
    end
  end

  context '.last_updated_at' do

    it 'returns max updated_at' do
      Timecop.freeze(Time.now)
      game1 = create(:game)
      game2 = create(:game)
      game1.update_column(:updated_at, Time.now + 5.minutes)
      expect(subject.last_updated_at).to be_equal_to_time(game1.updated_at)

      game2.update_column(:updated_at, Time.now + 10.minutes)
      expect(subject.last_updated_at).to be_equal_to_time(game2.updated_at)
    end
  end

  context '.started_games' do

    it 'returns games where start_date < Time.now' do
      Timecop.freeze(Time.now)
      game1 = create(:game, start_at: Time.now - 1.minute)
      game2 = create(:game, start_at: Time.now + 1.minute)
      game3 = create(:game, start_at: Time.now + 1.day)

      games = subject.started_games
      expect(games.to_a).to eq([game1])

      game2.update_column(:start_at, Time.now)
      games = subject.started_games
      expect(games.to_a).to eq([game1])

      game2.update_column(:start_at, Time.now - 1.second)
      games = subject.started_games
      expect(games.to_a).to eq([game1, game2])
    end
  end

  context '.for_round_ordered_by_started_at_asc' do

    let!(:game1) { create(:game, round: Game::GROUP,
                          group: Game::GROUP_A, start_at: Time.now + 1.day)}
    let!(:game2) { create(:game, round: Game::GROUP,
                          group: Game::GROUP_A, start_at: Time.now + 2.day)}
    let!(:game3) { create(:game, round: Game::GROUP,
                          group: Game::GROUP_B, start_at: Time.now - 2.day)}
    let!(:game4) { create(:game, round: Game::GROUP,
                          group: Game::GROUP_C, start_at: Time.now - 1.day)}

    let!(:game5) { create(:game, round: Game::SEMIFINAL,
                          group: nil, start_at: Time.now + 5.day)}


    it 'gets start and end date of group-round' do
      ordered_started_at_asc = subject.ordered_started_at_for(Game::GROUP)
      expected = [game3.start_at, game4.start_at, game1.start_at, game2.start_at]
      expect(ordered_started_at_asc.map(&:to_i)).to eql(expected.map(&:to_i))
    end

  end


end