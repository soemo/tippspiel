require 'rails_helper'

describe Results::FootballDataAdapter do

  describe '.from_hash' do
    let(:base_hash) do
      {
        'id'       => 12345,
        'utcDate'  => '2026-06-15T18:00:00Z',
        'status'   => 'FINISHED',
        'homeTeam' => { 'tla' => 'GER' },
        'awayTeam' => { 'tla' => 'BRA' },
        'score'    => {
          'duration' => 'REGULAR',
          'fullTime' => { 'home' => 2, 'away' => 1 }
        }
      }
    end

    it 'maps a complete FD hash to a Match struct' do
      m = described_class.from_hash(base_hash)
      expect(m.fd_id).to eq 12345
      expect(m.home_tla).to eq 'GER'
      expect(m.away_tla).to eq 'BRA'
      expect(m.status).to eq 'FINISHED'
      expect(m.home_goals).to eq 2
      expect(m.away_goals).to eq 1
      expect(m.duration).to eq 'REGULAR'
      expect(m.utc_date).to eq Time.zone.parse('2026-06-15T18:00:00Z')
    end

    it 'still takes fullTime score for EXTRA_TIME duration' do
      base_hash['score']['duration'] = 'EXTRA_TIME'
      base_hash['score']['fullTime'] = { 'home' => 3, 'away' => 2 }
      m = described_class.from_hash(base_hash)
      expect(m.home_goals).to eq 3
      expect(m.away_goals).to eq 2
      expect(m.duration).to eq 'EXTRA_TIME'
    end

    it 'still takes fullTime score for PENALTY_SHOOTOUT duration' do
      base_hash['score']['duration'] = 'PENALTY_SHOOTOUT'
      base_hash['score']['fullTime'] = { 'home' => 4, 'away' => 3 }
      m = described_class.from_hash(base_hash)
      expect(m.home_goals).to eq 4
      expect(m.away_goals).to eq 3
      expect(m.duration).to eq 'PENALTY_SHOOTOUT'
    end

    it 'returns nil for nil input' do
      expect(described_class.from_hash(nil)).to be_nil
    end

    it 'returns nil when required fields are missing' do
      base_hash.delete('id')
      expect(described_class.from_hash(base_hash)).to be_nil
    end

    it 'tolerates a missing fullTime block (scheduled but not started)' do
      base_hash['score'] = { 'duration' => 'REGULAR' }
      base_hash['status'] = 'SCHEDULED'
      m = described_class.from_hash(base_hash)
      expect(m.home_goals).to be_nil
      expect(m.away_goals).to be_nil
      expect(m.status).to eq 'SCHEDULED'
    end
  end

  describe '.from_payload' do
    it 'returns [] for a payload without matches' do
      expect(described_class.from_payload({})).to eq []
      expect(described_class.from_payload(nil)).to eq []
    end

    it 'maps and compacts malformed entries' do
      payload = {
        'matches' => [
          { 'id' => 1, 'utcDate' => '2026-06-15T18:00:00Z', 'homeTeam' => { 'tla' => 'GER' }, 'awayTeam' => { 'tla' => 'BRA' }, 'score' => { 'fullTime' => { 'home' => 1, 'away' => 0 }, 'duration' => 'REGULAR' }, 'status' => 'FINISHED' },
          nil,
          { 'id' => nil }
        ]
      }
      result = described_class.from_payload(payload)
      expect(result.size).to eq 1
      expect(result.first.fd_id).to eq 1
    end
  end

end
