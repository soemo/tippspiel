require 'rails_helper'

describe Results::BackfillFootballDataIds do

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

  let(:base_time) { Time.zone.parse('2026-06-15T18:00:00Z') }

  def fd_match(overrides = {})
    {
      'id'       => 9001,
      'utcDate'  => '2026-06-15T18:00:00Z',
      'status'   => 'SCHEDULED',
      'homeTeam' => { 'tla' => 'GER' },
      'awayTeam' => { 'tla' => 'BRA' },
      'score'    => { 'duration' => 'REGULAR', 'fullTime' => { 'home' => nil, 'away' => nil } }
    }.merge(overrides)
  end

  let!(:ger) { create(:team, name: 'Germany', football_data_tla: 'GER') }
  let!(:bra) { create(:team, name: 'Brazil',  football_data_tla: 'BRA') }

  it 'links an unambiguous match and writes the FD id' do
    game = create(:game, team1: ger, team2: bra, start_at: base_time, football_data_match_id: nil)
    entries = described_class.new(client: build_client('matches' => [fd_match])).call
    expect(entries.size).to eq 1
    expect(entries.first.status).to eq :linked
    expect(game.reload.football_data_match_id).to eq 9001
  end

  it 'reports already_linked on idempotent re-run' do
    create(:game, team1: ger, team2: bra, start_at: base_time, football_data_match_id: 9001)
    entries = described_class.new(client: build_client('matches' => [fd_match])).call
    expect(entries.first.status).to eq :already_linked
  end

  it 'reports tla_missing when a team is not in the DB' do
    entries = described_class.new(
      client: build_client('matches' => [fd_match('awayTeam' => { 'tla' => 'NOP' })])
    ).call
    expect(entries.first.status).to eq :tla_missing
  end

  it 'reports unmatched when no game in time window' do
    entries = described_class.new(client: build_client('matches' => [fd_match])).call
    expect(entries.first.status).to eq :unmatched
  end

  it 'reports placeholder when only a placeholder game exists in the window' do
    create(:game, team1: nil, team2: nil, start_at: base_time, football_data_match_id: nil,
                  team1_placeholder_name: 'W1', team2_placeholder_name: 'W2')
    entries = described_class.new(client: build_client('matches' => [fd_match])).call
    expect(entries.first.status).to eq :placeholder
  end

  it 'reports ambiguous when multiple games match' do
    create(:game, team1: ger, team2: bra, start_at: base_time)
    create(:game, team1: ger, team2: bra, start_at: base_time + 1.hour)
    entries = described_class.new(client: build_client('matches' => [fd_match])).call
    expect(entries.first.status).to eq :ambiguous
  end

  it 'reports time_mismatch when single match is found but drift > 1h' do
    game = create(:game, team1: ger, team2: bra, start_at: base_time + 4.hours)
    entries = described_class.new(client: build_client('matches' => [fd_match])).call
    expect(entries.first.status).to eq :time_mismatch
    expect(game.reload.football_data_match_id).to eq 9001 # still links, but flags
  end

end
