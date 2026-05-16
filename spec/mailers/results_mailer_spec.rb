require 'rails_helper'

describe ResultsMailer do

  let(:team1) { build_stubbed(:team, name: 'Germany', football_data_tla: 'GER') }
  let(:team2) { build_stubbed(:team, name: 'Brazil',  football_data_tla: 'BRA') }
  let(:game) do
    build_stubbed(:game,
                  team1: team1, team2: team2,
                  start_at: Time.zone.parse('2026-06-15T18:00:00Z'),
                  place: 'Berlin', round: 'Group A', group: 'A',
                  football_data_match_id: 9001)
  end

  let(:imported_entry) do
    Results::ImportFinishedGames::ImportedGame.new(
      game: game, home_goals: 2, away_goals: 1, duration: 'REGULAR'
    )
  end

  let(:discrepancy_entry) do
    Results::ImportFinishedGames::Discrepancy.new(
      game: game, db_score: [5, 0], fd_score: [2, 1],
      fd_status: 'FINISHED', duration: 'REGULAR'
    )
  end

  let(:unmatched_entry) do
    fd = Results::FootballDataAdapter::Match.new(
      fd_id: 9002, home_tla: 'ARG', away_tla: 'FRA',
      utc_date: Time.zone.parse('2026-06-16T20:00:00Z'),
      status: 'FINISHED', home_goals: 3, away_goals: 3,
      duration: 'PENALTY_SHOOTOUT'
    )
    Results::ImportFinishedGames::Unmatched.new(fd_match: fd, reason: :no_match)
  end

  describe '.import_summary' do
    it 'sends to ADMIN_EMAIL' do
      result = Results::ImportFinishedGames::Result.new(
        imported: [imported_entry], discrepancies: [], unmatched: []
      )
      mail = described_class.import_summary(result)
      expect(mail.to).to eq [ADMIN_EMAIL]
    end

    it 'includes imported games in the body' do
      result = Results::ImportFinishedGames::Result.new(
        imported: [imported_entry], discrepancies: [], unmatched: []
      )
      mail = described_class.import_summary(result)
      body = mail.body.to_s
      expect(body).to include 'Germany'
      expect(body).to include 'Brazil'
      expect(body).to include '2:1'
      expect(body).to include '9001'
    end

    it 'includes discrepancies and reports DB vs FD scores' do
      result = Results::ImportFinishedGames::Result.new(
        imported: [], discrepancies: [discrepancy_entry], unmatched: []
      )
      mail = described_class.import_summary(result)
      body = mail.body.to_s
      expect(body).to include 'DISCREPANCIES'
      expect(body).to include 'DB: 5:0'
      expect(body).to include 'FD: 2:1'
    end

    it 'includes unmatched FD matches with their tlas' do
      result = Results::ImportFinishedGames::Result.new(
        imported: [], discrepancies: [], unmatched: [unmatched_entry]
      )
      mail = described_class.import_summary(result)
      body = mail.body.to_s
      expect(body).to include 'ARG'
      expect(body).to include 'FRA'
      expect(body).to include '9002'
      expect(body).to match(/penalty[ _]shootout/i)
    end

    it 'builds a subject summarising counts' do
      result = Results::ImportFinishedGames::Result.new(
        imported: [imported_entry], discrepancies: [discrepancy_entry], unmatched: []
      )
      mail = described_class.import_summary(result)
      expect(mail.subject).to include '1 imported'
      expect(mail.subject).to include '1 discrepancies'
    end
  end

end
