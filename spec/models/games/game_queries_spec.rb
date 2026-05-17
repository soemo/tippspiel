# frozen_string_literal: true

require 'rails_helper'

describe GameQueries do
  subject { described_class }

  describe '::all_ordered_by_start_at' do
    it 'returns games ordered by start_at asc' do
      Timecop.freeze(Time.zone.now)
      game1 = create(:game, start_at: 1.minute.from_now)
      game2 = create(:game, start_at: 1.minute.ago)
      game3 = create(:game, start_at: 1.day.from_now)

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
      create(:game, start_at: '19.06.2012 20:45', round: GROUP)
      game2 = create(:game, start_at: '19.06.2012 20:45', round: FINAL)
      create(:game, start_at: '19.06.2012 20:45', round: FINAL) # es sollte nur ein finale geben

      expect(described_class.final_game).to eq(game2)
    end
  end

  describe '::finished' do
    it 'returns only finished games' do
      create(:game, start_at: '19.06.2012 20:45', finished: nil)
      create(:game, start_at: '19.06.2012 20:45', finished: false)
      game3 = create(:game, start_at: '19.06.2012 20:45', finished: true)

      expect(described_class.finished).to eq([game3])
    end
  end

  describe '::first_game_in_tournament' do
    it 'returns first game' do
      Timecop.freeze(Time.zone.now)
      create(:game, start_at: 1.day.ago)
      game2 = create(:game, start_at: 5.days.ago)
      create(:game, start_at: 1.day.from_now)

      game = subject.first_game_in_tournament
      expect(game).to eq(game2)
    end
  end

  describe '::started_games_ordered_by_start_at' do
    it 'returns games where start_date <= Time.now' do
      Timecop.freeze(Time.zone.now)

      game1 = create(:game, start_at: 1.second.ago)
      game2 = create(:game, start_at: 1.hour.ago)
      game3 = create(:game, start_at: 1.second.from_now)

      games = subject.started_games_ordered_by_start_at
      expect(games.to_a).to eq([game2, game1])

      game3.update_column(:start_at, Time.zone.now)
      games = subject.started_games_ordered_by_start_at
      expect(games.to_a).to eq([game2, game1, game3])
    end
  end

  describe '::started_game_ids' do
    it 'returns game ids where start_date <= Time.now' do
      Timecop.freeze(Time.zone.now)

      game1 = create(:game, start_at: 1.second.ago)
      game2 = create(:game, start_at: 1.hour.ago)
      game3 = create(:game, start_at: 1.second.from_now)

      game_ids = subject.started_game_ids
      expect(game_ids).to eq([game1.id, game2.id])

      game3.update_column(:start_at, Time.zone.now)
      game_ids = subject.started_game_ids
      expect(game_ids).to eq([game1.id, game2.id, game3.id])
    end
  end

  describe '::ordered_started_at_for' do
    let!(:game1) do
      create(:game, round: GROUP,
                    group: GROUP_A, start_at: 1.day.from_now)
    end
    let!(:game2) do
      create(:game, round: GROUP,
                    group: GROUP_A, start_at: 2.days.from_now)
    end
    let!(:game3) do
      create(:game, round: GROUP,
                    group: GROUP_B, start_at: 2.days.ago)
    end
    let!(:game4) do
      create(:game, round: GROUP,
                    group: GROUP_C, start_at: 1.day.ago)
    end

    let!(:game5) do
      create(:game, round: SEMIFINAL,
                    group: nil, start_at: 5.days.from_now)
    end

    it 'gets start and end date of group-round' do
      ordered_started_at_asc = subject.ordered_started_at_for(GROUP)
      expected = [game3.start_at, game4.start_at, game1.start_at, game2.start_at]
      expect(ordered_started_at_asc.map(&:to_i)).to eql(expected.map(&:to_i))
    end
  end

  describe '::all_finished_ordered_by_start_at' do
    let!(:game1) do
      create(:game,
             finished: true,
             round: GROUP,
             group: GROUP_A,
             start_at: 1.day.from_now)
    end
    let!(:game2) do
      create(:game,
             finished: true,
             round: GROUP,
             group: GROUP_A,
             start_at: 2.days.from_now)
    end
    let!(:game3) do
      create(:game,
             finished: true,
             round: GROUP,
             group: GROUP_B,
             start_at: 2.days.ago)
    end
    let!(:game4) do
      create(:game,
             finished: false,
             round: GROUP,
             group: GROUP_C,
             start_at: 1.day.ago)
    end

    it 'returns finished games ordered by start_at' do
      games = subject.all_finished_ordered_by_start_at
      expect(games).to eq([
                            game3,
                            game1,
                            game2
                          ])
      expect(games[0].association(:tips)).not_to be_loaded
      expect(games[1].association(:tips)).not_to be_loaded
      expect(games[2].association(:tips)).not_to be_loaded
    end
  end

  describe '::all_finished_ordered_by_start_at_with_preload_tips' do
    let!(:game1) do
      create(:game,
             finished: true,
             round: GROUP,
             group: GROUP_A,
             start_at: 1.day.from_now)
    end
    let!(:game2) do
      create(:game,
             finished: true,
             round: GROUP,
             group: GROUP_A,
             start_at: 2.days.from_now)
    end
    let!(:game3) do
      create(:game,
             finished: true,
             round: GROUP,
             group: GROUP_B,
             start_at: 2.days.ago)
    end
    let!(:game4) do
      create(:game,
             finished: false,
             round: GROUP,
             group: GROUP_C,
             start_at: 1.day.ago)
    end

    it 'returns finished games ordered by start_at with preloading tips' do
      games = subject.all_finished_ordered_by_start_at_with_preload_tips
      expect(games).to eq([
                            game3,
                            game1,
                            game2
                          ])

      expect(games[0].association(:tips)).to be_loaded
      expect(games[1].association(:tips)).to be_loaded
      expect(games[2].association(:tips)).to be_loaded
    end
  end

  describe '::tournament_champion_team' do
    context 'when the final has a winner' do
      it 'returns the winning team' do
        winner = create(:team, name: 'Winner')
        loser  = create(:team, name: 'Loser')
        create(:final, team1: loser, team2: winner, team1_goals: 0, team2_goals: 1, finished: true)

        expect(subject.tournament_champion_team).to eq(winner)
      end
    end

    context 'when the final ended in a draw' do
      it 'returns nil' do
        create(:final, team1_goals: 1, team2_goals: 1, finished: true)

        expect(subject.tournament_champion_team).to be_nil
      end
    end

    context 'when there is no final game' do
      it 'returns nil' do
        expect(subject.tournament_champion_team).to be_nil
      end
    end
  end

  describe '::tournament_second_team' do
    context 'when the final has a winner' do
      it 'returns the losing team' do
        winner = create(:team, name: 'Winner')
        loser  = create(:team, name: 'Loser')
        create(:final, team1: loser, team2: winner, team1_goals: 0, team2_goals: 1, finished: true)

        expect(subject.tournament_second_team).to eq(loser)
      end
    end

    context 'when the final ended in a draw' do
      it 'returns nil' do
        create(:final, team1_goals: 1, team2_goals: 1, finished: true)

        expect(subject.tournament_second_team).to be_nil
      end
    end

    context 'when there is no final game' do
      it 'returns nil' do
        expect(subject.tournament_second_team).to be_nil
      end
    end
  end
end
