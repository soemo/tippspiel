require 'rails_helper'

describe GameQueries do

  subject { GameQueries }

  context '#started_games' do

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