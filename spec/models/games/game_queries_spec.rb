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

end