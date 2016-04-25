require 'rails_helper'

describe GameQueries do

  subject { GameQueries }

  describe '::all_ordered_by_start_at' do

    it 'returns games ordered by start_at asc' do
      Timecop.freeze(Time.now)
      game1 = create(:game, start_at: Time.now + 1.minute)
      game2 = create(:game, start_at: Time.now - 1.minute)
      game3 = create(:game, start_at: Time.now + 1.day)

      expect(subject.all_ordered_by_start_at).to eq([game2, game1, game3])
    end

  end

  describe '::all_game_ids' do

    it 'returns ids of all games' do
      game1 = create(:game)
      game2 = create(:game)
      game3 = create(:game)

      expect(subject.all_game_ids).to eq([game1.id, game2.id, game3.id])
    end
  end

  describe '::final_game' do

    it 'returns the first( and only) final games' do
      game1 = create(:game, start_at: '19.06.2012 20:45', round: GROUP)
      game2 = create(:game, start_at: '19.06.2012 20:45', round: FINAL)
      game3 = create(:game, start_at: '19.06.2012 20:45', round: FINAL) # es sollte nur ein finale geben

      expect(GameQueries.final_game).to eq(game2)
    end
  end

  describe '::finished' do

    it 'returns only finished games' do
      game1 = create(:game, start_at: '19.06.2012 20:45', finished: nil)
      game2 = create(:game, start_at: '19.06.2012 20:45', finished: false)
      game3 = create(:game, start_at: '19.06.2012 20:45', finished: true)

      expect(GameQueries.finished).to eq([game3])
    end
  end

  describe '::first_game_in_tournament' do

    it 'returns first game' do
      Timecop.freeze(Time.now)
      game1 = create(:game, start_at: Time.now - 1.day)
      game2 = create(:game, start_at: Time.now - 5.days)
      game3 = create(:game, start_at: Time.now + 1.day)

      game = subject.first_game_in_tournament
      expect(game).to eq(game2)
    end
  end

  describe '::last_updated_at' do

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

  describe '::started_games' do

    it 'returns games where start_date <= Time.now' do
      Timecop.freeze(Time.now)

      game1 = create(:game, start_at: Time.now - 1.second)
      game2 = create(:game, start_at: Time.now + 1.second)

      games = subject.started_games
      expect(games.to_a).to eq([game1])

      game2.update_column(:start_at, Time.now)
      games = subject.started_games
      expect(games.to_a).to eq([game1, game2])
    end
  end

  describe '::ordered_started_at_for' do

    let!(:game1) { create(:game, round: GROUP,
                          group: GROUP_A, start_at: Time.now + 1.day)}
    let!(:game2) { create(:game, round: GROUP,
                          group: GROUP_A, start_at: Time.now + 2.day)}
    let!(:game3) { create(:game, round: GROUP,
                          group: GROUP_B, start_at: Time.now - 2.day)}
    let!(:game4) { create(:game, round: GROUP,
                          group: GROUP_C, start_at: Time.now - 1.day)}

    let!(:game5) { create(:game, round: SEMIFINAL,
                          group: nil, start_at: Time.now + 5.day)}


    it 'gets start and end date of group-round' do
      ordered_started_at_asc = subject.ordered_started_at_for(GROUP)
      expected = [game3.start_at, game4.start_at, game1.start_at, game2.start_at]
      expect(ordered_started_at_asc.map(&:to_i)).to eql(expected.map(&:to_i))
    end
  end

  describe '::all_finished_ordered_by_start_at' do

    let!(:game1) { create(:game,
                          finished: true,
                          round: GROUP,
                          group: GROUP_A,
                          start_at: Time.now + 1.day)}
    let!(:game2) { create(:game,
                          finished: true,
                          round: GROUP,
                          group: GROUP_A,
                          start_at: Time.now + 2.day)}
    let!(:game3) { create(:game,
                          finished: true,
                          round: GROUP,
                          group: GROUP_B,
                          start_at: Time.now - 2.day)}
    let!(:game4) { create(:game,
                          finished: false,
                          round: GROUP,
                          group: GROUP_C,
                          start_at: Time.now - 1.day)}

    it 'returns finished games ordered by start_at' do
      expect(subject.all_finished_ordered_by_start_at.to_a).to eq([
                                                              game3,
                                                              game1,
                                                              game2
                                                            ])
    end

  end
end