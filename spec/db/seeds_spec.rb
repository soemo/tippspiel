# frozen_string_literal: true

require 'rails_helper'
require_relative '../../db/seeds/wm2026'

# Tests the WM 2026 seed data integrity.
# Uses Seeds::Wm2026 module directly — no DB writes, fast and isolated.

describe 'WM 2026 seed data' do
  let(:data)              { Seeds::Wm2026.game_data }
  let(:group_games)       { data.select { |g| g[:round] == 'group' } }
  let(:round_of_32_games) { data.select { |g| g[:round] == 'roundof32' } }
  let(:round_of_16_games) { data.select { |g| g[:round] == 'roundof16' } }
  let(:quarterfinal_games) { data.select { |g| g[:round] == 'quarterfinal' } }
  let(:semifinal_games)   { data.select { |g| g[:round] == 'semifinal' } }
  let(:place3_games)      { data.select { |g| g[:round] == 'place3' } }
  let(:final_games)       { data.select { |g| g[:round] == 'final' } }

  describe 'total game count' do
    it 'has exactly 104 games' do
      expect(data.length).to eq(104)
    end
  end

  describe 'group' do
    it 'has 72 group games (12 groups × 6 games each)' do
      expect(group_games.length).to eq(72)
    end

    it 'covers all 12 groups A-L' do
      groups_in_data = group_games.map { |g| g[:group] }.uniq.sort
      expect(groups_in_data).to eq(%w[A B C D E F G H I J K L])
    end

    it 'has exactly 6 games per group' do
      %w[A B C D E F G H I J K L].each do |group|
        count = group_games.count { |g| g[:group] == group }
        expect(count).to eq(6), "Expected 6 games in group #{group}, got #{count}"
      end
    end

    it 'has 48 unique teams across all groups' do
      team_names = group_games.flat_map { |g| [g[:team1_name], g[:team2_name]] }.uniq.compact
      expect(team_names.length).to eq(48)
    end

    it 'has 4 teams per group' do
      %w[A B C D E F G H I J K L].each do |group|
        games = group_games.select { |g| g[:group] == group }
        teams = games.flat_map { |g| [g[:team1_name], g[:team2_name]] }.uniq.compact
        expect(teams.length).to eq(4), "Expected 4 teams in group #{group}, got #{teams.length}"
      end
    end
  end

  describe 'Round of 32' do
    it 'has 16 games' do
      expect(round_of_32_games.length).to eq(16)
    end

    it 'all games have placeholder names (no named teams)' do
      round_of_32_games.each do |g|
        expect(g[:team1_name]).to be_nil
        expect(g[:team2_name]).to be_nil
        expect(g[:team1_placeholder_name]).to be_present
        expect(g[:team2_placeholder_name]).to be_present
      end
    end

    it 'has no group assigned' do
      round_of_32_games.each do |g|
        expect(g[:group]).to be_nil
      end
    end
  end

  describe 'Round of 16' do
    it 'has 8 games' do
      expect(round_of_16_games.length).to eq(8)
    end
  end

  describe 'Quarter-finals' do
    it 'has 4 games' do
      expect(quarterfinal_games.length).to eq(4)
    end
  end

  describe 'Semi-finals' do
    it 'has 2 games' do
      expect(semifinal_games.length).to eq(2)
    end
  end

  describe 'Third place match' do
    it 'has 1 game' do
      expect(place3_games.length).to eq(1)
    end
  end

  describe 'Final' do
    it 'has 1 game' do
      expect(final_games.length).to eq(1)
    end
  end

  describe 'all teams have a country code mapping' do
    it 'every team in the seed data has a country code' do
      codes = Seeds::Wm2026.country_code_map
      team_names = group_games.flat_map { |g| [g[:team1_name], g[:team2_name]] }.uniq.compact
      missing = team_names.reject { |name| codes.key?(name) }
      expect(missing).to be_empty, "Teams missing country codes: #{missing.join(', ')}"
    end
  end

  describe 'all teams have a football-data tla mapping' do
    let(:tla_map) { Seeds::Wm2026.football_data_tla_map }

    it 'every team in the seed data has a tla' do
      team_names = group_games.flat_map { |g| [g[:team1_name], g[:team2_name]] }.uniq.compact
      missing = team_names.reject { |name| tla_map.key?(name) }
      expect(missing).to be_empty, "Teams missing football_data_tla: #{missing.join(', ')}"
    end

    it 'all tlas are 3-letter uppercase strings' do
      tla_map.each_value do |tla|
        expect(tla).to match(/\A[A-Z]{3}\z/), "Invalid tla: #{tla.inspect}"
      end
    end

    it 'tlas are unique across all teams' do
      duplicates = tla_map.values.tally.select { |_, count| count > 1 }
      expect(duplicates).to be_empty, "Duplicate tlas: #{duplicates}"
    end
  end

  describe 'tournament dates' do
    it 'first game is on 11 June 2026' do
      first_date = data.map { |g| Date.strptime(g[:start_at], '%d.%m.%Y') }.min
      expect(first_date).to eq(Date.new(2026, 6, 11))
    end

    it 'final is on 19 July 2026' do
      final_date = Date.strptime(final_games.first[:start_at], '%d.%m.%Y')
      expect(final_date).to eq(Date.new(2026, 7, 19))
    end
  end
end
