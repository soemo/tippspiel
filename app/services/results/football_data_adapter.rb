# frozen_string_literal: true

# Converts a single football-data.org match JSON hash into a flat struct
# with only the fields we care about. Pure — no I/O, no DB.
#
# Notes on `score`:
#   - `score.fullTime.{home,away}` is the canonical final score and ALWAYS
#     reflects the result including extra time and penalty shootout, per
#     https://docs.football-data.org/general/v4/overtime.html
#   - `score.duration` is one of REGULAR | EXTRA_TIME | PENALTY_SHOOTOUT
#     and is captured for logging / audit purposes only.
module Results
  class FootballDataAdapter

    Match = Struct.new(
      :fd_id,
      :home_tla,
      :away_tla,
      :utc_date,
      :status,
      :home_goals,
      :away_goals,
      :duration,
      keyword_init: true
    )

    # Accepts a single FD match Hash and returns a Match struct (or nil if
    # the hash is too malformed to be usable — caller should treat nil as
    # "skip this entry, log a warning").
    def self.from_hash(hash)
      return nil unless hash.is_a?(Hash)

      fd_id    = hash['id']
      home     = hash.dig('homeTeam', 'tla')
      away     = hash.dig('awayTeam', 'tla')
      utc_date = hash['utcDate']
      status   = hash['status']

      return nil if fd_id.blank? || home.blank? || away.blank? || utc_date.blank?

      full_time = hash.dig('score', 'fullTime') || {}

      Match.new(
        fd_id:      fd_id,
        home_tla:   home,
        away_tla:   away,
        utc_date:   Time.zone.parse(utc_date),
        status:     status,
        home_goals: full_time['home'],
        away_goals: full_time['away'],
        duration:   hash.dig('score', 'duration')
      )
    end

    # Convenience: convert the full list payload returned by
    # `FootballDataClient#fetch_competition_matches`.
    def self.from_payload(payload)
      matches = (payload || {})['matches'] || []
      matches.map { |m| from_hash(m) }.compact
    end

  end
end
