# frozen_string_literal: true

# One-shot pre-tournament data-quality task. Walks all WC matches in the FD
# API and tries to link each to one of our Game rows via fuzzy match on
# teams + start_at. Writes football_data_match_id on unambiguous hits.
#
# Reports each row as one of:
#   :already_linked  → game already has the FD id (idempotent re-run)
#   :linked          → freshly linked (fuzzy match succeeded, FD id written)
#   :placeholder     → our game still has placeholder teams (knockout pre-draw)
#   :ambiguous       → multiple candidate games matched (should never happen)
#   :unmatched       → no candidate game found
#   :time_mismatch   → match found but start_at drift > 1 hour (flag for review)
#   :tla_missing     → team(s) not in our DB by football_data_tla — seed gap
module Results
  class BackfillFootballDataIds < BaseService
    TIME_DRIFT_WARNING_SECONDS = 60 * 60         # >1h drift is worth surfacing
    TIME_TOLERANCE_SECONDS     = 6 * 60 * 60     # matches ImportFinishedGames

    Entry = Struct.new(:status, :fd_match, :game, :detail, keyword_init: true)

    def initialize(client: FootballDataClient.new) # rubocop:disable Lint/MissingSuper -- BaseService uses Virtus.model; this service has no Virtus attributes, super is unnecessary
      @client = client
    end

    def call
      # Competition code (WC vs EC) is set in 01_constants.rb based on IS_WM/IS_EM.
      payload    = @client.fetch_competition_matches
      fd_matches = FootballDataAdapter.from_payload(payload)

      fd_matches.map { |fd| process(fd) }
    end

    private

    def process(fd) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize -- match-linking algorithm with multiple candidate states
      # Use with_deleted so a soft-deleted game that already holds this FD id
      # is visible — the plain unique index applies to all rows, so without
      # with_deleted a subsequent update_column would raise RecordNotUnique.
      existing = Game.with_deleted.find_by(football_data_match_id: fd.fd_id)
      return Entry.new(status: :already_linked, fd_match: fd, game: existing) if existing

      team1 = Team.find_by(football_data_tla: fd.home_tla)
      team2 = Team.find_by(football_data_tla: fd.away_tla)
      missing = []
      missing << fd.home_tla unless team1
      missing << fd.away_tla unless team2
      return Entry.new(status: :tla_missing, fd_match: fd, detail: "Unknown tla: #{missing.join(', ')}") if missing.any?

      lower = fd.utc_date - TIME_TOLERANCE_SECONDS
      upper = fd.utc_date + TIME_TOLERANCE_SECONDS

      candidates = Game.where(start_at: lower..upper).where(
        '(team1_id = ? AND team2_id = ?) OR (team1_id = ? AND team2_id = ?)',
        team1.id, team2.id, team2.id, team1.id
      )

      case candidates.size
      when 0
        # No team match in time window — maybe still placeholder?
        placeholder_candidate = Game.where(start_at: lower..upper)
                                    .where('team1_id IS NULL OR team2_id IS NULL').first
        if placeholder_candidate
          Entry.new(status: :placeholder, fd_match: fd, game: placeholder_candidate)
        else
          Entry.new(status: :unmatched, fd_match: fd)
        end
      when 1
        game = candidates.first
        game.update_column(:football_data_match_id, fd.fd_id) # rubocop:disable Rails/SkipsModelValidations -- intentional: lock id without triggering callbacks
        drift = (game.start_at - fd.utc_date).abs
        if drift > TIME_DRIFT_WARNING_SECONDS
          Entry.new(status: :time_mismatch, fd_match: fd, game: game,
                    detail: "start_at drift: #{drift.to_i}s (DB: #{game.start_at}, FD: #{fd.utc_date})")
        else
          Entry.new(status: :linked, fd_match: fd, game: game)
        end
      else
        Entry.new(status: :ambiguous, fd_match: fd,
                  detail: "#{candidates.size} candidates: #{candidates.pluck(:id).inspect}")
      end
    end
  end
end
