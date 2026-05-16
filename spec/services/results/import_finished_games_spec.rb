require 'rails_helper'

describe Results::ImportFinishedGames do

  # Anonymous fake — avoids hitting Net::HTTP and lets us return any payload.
  # Defined as a `let` so it doesn't leak as a top-level constant (which would
  # collide with the equivalent helper in the backfill spec when both run in
  # the same process).
  let(:fake_client_class) do
    Class.new do
      def initialize(payload)
        @payload = payload
      end

      def fetch_competition_matches(competition_code: nil, status: nil)
        @payload
      end
    end
  end

  def build_client(payload)
    fake_client_class.new(payload)
  end

  def fd_match(overrides = {})
    {
      'id'       => 9001,
      'utcDate'  => '2026-06-15T18:00:00Z',
      'status'   => 'FINISHED',
      'homeTeam' => { 'tla' => 'GER' },
      'awayTeam' => { 'tla' => 'BRA' },
      'score'    => { 'duration' => 'REGULAR', 'fullTime' => { 'home' => 2, 'away' => 1 } }
    }.merge(overrides)
  end

  def payload(*matches)
    { 'matches' => matches }
  end

  let!(:ger) { create(:team, name: 'Germany', football_data_tla: 'GER') }
  let!(:bra) { create(:team, name: 'Brazil',  football_data_tla: 'BRA') }

  let(:base_time) { Time.zone.parse('2026-06-15T18:00:00Z') }

  before do
    # Avoid hitting the ranking pipeline for the orchestrator's behaviour tests.
    allow(Tips::UpdatePoints).to receive(:call)
    allow(Users::UpdatePoints).to receive(:call)
    allow(Users::UpdateRankingPerGame).to receive(:call)
  end

  # ---- Case 1: link by football_data_match_id (already linked) ----
  it 'updates an unfinished game already linked by FD id and triggers ranking' do
    game = create(:game,
                  team1: ger, team2: bra, start_at: base_time,
                  finished: false, team1_goals: 0, team2_goals: 0,
                  football_data_match_id: 9001)

    result = described_class.new(client: build_client(payload(fd_match))).call

    game.reload
    expect(game.team1_goals).to eq 2
    expect(game.team2_goals).to eq 1
    expect(game.finished?).to be true
    expect(result.imported.size).to eq 1
    expect(result.discrepancies).to be_empty
    expect(result.unmatched).to be_empty
    expect(Tips::UpdatePoints).to have_received(:call).once
  end

  # ---- Case 2: fuzzy match by tla + time, writes FD id back ----
  it 'fuzzy-matches by tla+time and writes back the FD id' do
    game = create(:game,
                  team1: ger, team2: bra,
                  start_at: base_time + 3.hours,
                  finished: false, team1_goals: 0, team2_goals: 0,
                  football_data_match_id: nil)

    described_class.new(client: build_client(payload(fd_match))).call

    game.reload
    expect(game.football_data_match_id).to eq 9001
    expect(game.finished?).to be true
  end

  # ---- Case 2b: swapped home/away — score persisted in our home/away order ----
  it 'detects swapped teams and swaps goals to our orientation' do
    game = create(:game,
                  team1: bra, team2: ger, # reversed
                  start_at: base_time,
                  finished: false, team1_goals: 0, team2_goals: 0,
                  football_data_match_id: 9001)

    described_class.new(client: build_client(payload(fd_match))).call

    game.reload
    # FD said GER 2 - BRA 1. Our team1 is BRA → 1, team2 GER → 2.
    expect(game.team1_goals).to eq 1
    expect(game.team2_goals).to eq 2
    expect(game.finished?).to be true
  end

  # ---- Case 3: already finished, same score → silent skip ----
  it 'silently skips an already-finished game with matching score' do
    game = create(:game,
                  team1: ger, team2: bra, start_at: base_time,
                  finished: true, team1_goals: 2, team2_goals: 1,
                  football_data_match_id: 9001)

    result = described_class.new(client: build_client(payload(fd_match))).call

    expect(result.imported).to be_empty
    expect(result.discrepancies).to be_empty
    expect(Tips::UpdatePoints).not_to have_received(:call)
    game.reload
    expect(game.team1_goals).to eq 2
  end

  # ---- Case 4: already finished, different score → discrepancy, no overwrite ----
  it 'collects a discrepancy when finished game disagrees with FD' do
    game = create(:game,
                  team1: ger, team2: bra, start_at: base_time,
                  finished: true, team1_goals: 5, team2_goals: 0,
                  football_data_match_id: 9001)

    result = described_class.new(client: build_client(payload(fd_match))).call

    expect(result.imported).to be_empty
    expect(result.discrepancies.size).to eq 1
    expect(result.discrepancies.first.game.id).to eq game.id
    game.reload
    expect(game.team1_goals).to eq 5 # NOT overwritten
  end

  # ---- Case 5: DB finished, FD reports non-FINISHED status → discrepancy ----
  it 'collects a discrepancy when DB finished but FD no longer FINISHED' do
    create(:game,
           team1: ger, team2: bra, start_at: base_time,
           finished: true, team1_goals: 2, team2_goals: 1,
           football_data_match_id: 9001)

    result = described_class.new(client: build_client(payload(fd_match('status' => 'POSTPONED')))).call

    expect(result.discrepancies.size).to eq 1
    expect(result.discrepancies.first.fd_status).to eq 'POSTPONED'
  end

  # ---- Case 6: not finished, goals manually set → silent overwrite ----
  it 'silently overwrites unfinished game even if goals were manually set' do
    game = create(:game,
                  team1: ger, team2: bra, start_at: base_time,
                  finished: false, team1_goals: 9, team2_goals: 9,
                  football_data_match_id: 9001)

    described_class.new(client: build_client(payload(fd_match))).call

    game.reload
    expect(game.team1_goals).to eq 2
    expect(game.team2_goals).to eq 1
    expect(game.finished?).to be true
  end

  # ---- Case 7: unmatched FD finished match in the past with no candidate ----
  it 'surfaces unmatched past-finished FD matches' do
    # No games in DB at all.
    Game.delete_all
    allow(Time.zone).to receive(:now).and_return(base_time + 1.day)
    result = described_class.new(client: build_client(payload(fd_match))).call
    expect(result.unmatched.size).to eq 1
    expect(result.unmatched.first.fd_match.fd_id).to eq 9001
  end

  # ---- Future scheduled match with no candidate is NOT reported as unmatched ----
  it 'does not surface future scheduled FD matches as unmatched' do
    Game.delete_all
    allow(Time.zone).to receive(:now).and_return(base_time)
    fd = fd_match(
      'status' => 'SCHEDULED',
      'utcDate' => (base_time + 7.days).iso8601,
      'score' => { 'duration' => 'REGULAR', 'fullTime' => { 'home' => nil, 'away' => nil } }
    )
    result = described_class.new(client: build_client(payload(fd))).call
    expect(result.unmatched).to be_empty
  end

  # ---- WARN log when unmatched.any? (even with no imported games) ----
  it 'logs a WARN line when there are unmatched FD matches' do
    Game.delete_all
    allow(Time.zone).to receive(:now).and_return(base_time + 1.day)
    expect(Rails.logger).to receive(:warn).with(/could not be linked/)
    described_class.new(client: build_client(payload(fd_match))).call
  end

  # ---- Idempotency: re-running with no new finished games does NOT recompute rankings ----
  it 'does not run ranking pipeline when no game was imported' do
    create(:game,
           team1: ger, team2: bra, start_at: base_time,
           finished: true, team1_goals: 2, team2_goals: 1,
           football_data_match_id: 9001)

    described_class.new(client: build_client(payload(fd_match))).call

    expect(Tips::UpdatePoints).not_to have_received(:call)
    expect(Users::UpdatePoints).not_to have_received(:call)
    expect(Users::UpdateRankingPerGame).not_to have_received(:call)
  end

  # ---- Ranking pipeline runs once even with multiple imports ----
  it 'runs the ranking pipeline once for a batch of imports' do
    create(:team, name: 'Argentina', football_data_tla: 'ARG')
    create(:game,
           team1: ger, team2: bra, start_at: base_time,
           finished: false, team1_goals: 0, team2_goals: 0,
           football_data_match_id: 9001)
    create(:game,
           team1: ger, team2: Team.find_by(football_data_tla: 'ARG'),
           start_at: base_time + 1.day,
           finished: false, team1_goals: 0, team2_goals: 0,
           football_data_match_id: 9002)

    payload_two = payload(
      fd_match,
      fd_match(
        'id' => 9002,
        'utcDate' => (base_time + 1.day).iso8601,
        'awayTeam' => { 'tla' => 'ARG' },
        'score' => { 'duration' => 'REGULAR', 'fullTime' => { 'home' => 1, 'away' => 0 } }
      )
    )

    result = described_class.new(client: build_client(payload_two)).call

    expect(result.imported.size).to eq 2
    expect(Tips::UpdatePoints).to have_received(:call).once
    expect(Users::UpdatePoints).to have_received(:call).once
    expect(Users::UpdateRankingPerGame).to have_received(:call).once
  end

end
