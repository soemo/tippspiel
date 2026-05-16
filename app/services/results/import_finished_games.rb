# frozen_string_literal: true

# Imports finished game results from football-data.org for the active
# tournament (competition code driven by FOOTBALL_DATA_COMPETITION_CODE).
#
# Behaviour (decisions documented in the planning conversation):
#   - Only matches with status == FINISHED are touched.
#   - Final score is always taken from score.fullTime (includes ET/penalties).
#   - Games are matched by football_data_match_id first, then by fuzzy
#     team-pair + start_at (±6h). On first successful fuzzy match the FD id
#     is written back to lock in the link for future runs.
#   - Already-finished games are NEVER overwritten. If FD reports a different
#     score (or no longer reports FINISHED), it's collected as a discrepancy
#     for manual review via the summary email.
#   - Games with finished == false are silently overwritten even if goals
#     were set manually — `finished: false` is the unlock signal.
  #   - Unmatched FD matches are surfaced when the FD match is FINISHED and
  #     its utc_date is in the past but no DB game could be linked — avoids
  #     noise for future matches that simply aren't in our DB yet.
#   - One transaction per game (failed game ≠ rolled-back batch).
#   - Ranking pipeline is run inside its own transaction iff at least one
#     game was imported (mirrors Admin::StartCalculatingsController).
module Results
  class ImportFinishedGames < BaseService

    # ±6h window for fuzzy game match (rescheduling tolerance).
    TIME_TOLERANCE_SECONDS = 6 * 60 * 60

    Result = Struct.new(:imported, :discrepancies, :unmatched, keyword_init: true) do
      def changes?
        imported.any? || discrepancies.any?
      end
    end

    ImportedGame = Struct.new(:game, :home_goals, :away_goals, :duration, keyword_init: true)
    Discrepancy  = Struct.new(:game, :db_score, :fd_score, :fd_status, :duration, keyword_init: true)
    Unmatched    = Struct.new(:fd_match, :reason, keyword_init: true)

    def initialize(client: FootballDataClient.new)
      @client = client
    end

    def call
      # Fetch all matches (no status filter) so we can also detect Case 5:
      # a game we already marked finished, but FD no longer reports as FINISHED.
      # Competition code (WC vs EC) is set in 01_constants.rb based on IS_WM/IS_EM.
      payload    = @client.fetch_competition_matches
      fd_matches = FootballDataAdapter.from_payload(payload)

      imported      = []
      discrepancies = []
      unmatched     = []

      fd_matches.each do |fd|
        game = find_game_for(fd)

        unless game
          # Only surface unmatched FD matches if they were FINISHED in the past
          # AND no candidate game existed — keeps noise low during early stages.
          if fd.status == 'FINISHED' && fd.utc_date < Time.zone.now
            unmatched << Unmatched.new(fd_match: fd, reason: :no_match)
          end
          next
        end

        process_game(game, fd, imported: imported, discrepancies: discrepancies)
      end

      if imported.any?
        recalculate_rankings
      end

      # Surface unmatched-only runs in the log even when no email is sent.
      # The mailer intentionally suppresses unmatched-only summaries (Result#changes?),
      # but a TLA mapping bug looks identical to a quiet day from the UI alone,
      # so leave a breadcrumb here for ops.
      if unmatched.any?
        Rails.logger.warn(
          "Results::ImportFinishedGames: #{unmatched.size} FD match(es) could not be linked " \
          "(likely missing tla mapping or unresolved placeholder). " \
          "FD ids: #{unmatched.map { |u| u.fd_match.fd_id }.inspect}"
        )
      end

      Result.new(imported: imported, discrepancies: discrepancies, unmatched: unmatched)
    end

    private

    def find_game_for(fd)
      # Use with_deleted so a soft-deleted game that already holds this FD id
      # is visible — the plain unique index applies to all rows, so without
      # with_deleted a subsequent update_column would raise RecordNotUnique.
      direct = Game.with_deleted.find_by(football_data_match_id: fd.fd_id)
      return direct if direct

      team1 = Team.find_by(football_data_tla: fd.home_tla)
      team2 = Team.find_by(football_data_tla: fd.away_tla)
      return nil unless team1 && team2

      lower = fd.utc_date - TIME_TOLERANCE_SECONDS
      upper = fd.utc_date + TIME_TOLERANCE_SECONDS

      candidates = Game.where(start_at: lower..upper).where(
        '(team1_id = ? AND team2_id = ?) OR (team1_id = ? AND team2_id = ?)',
        team1.id, team2.id, team2.id, team1.id
      )

      # .one? avoids a second COUNT query compared to .count == 1 + .first.
      return nil unless candidates.one?

      game = candidates.first
      # Lock in the link so we never have to fuzzy-match this game again.
      game.update_column(:football_data_match_id, fd.fd_id)
      game
    end

    def process_game(game, fd, imported:, discrepancies:)
      teams_swapped = swapped?(game, fd)
      fd_home_for_db = teams_swapped ? fd.away_goals : fd.home_goals
      fd_away_for_db = teams_swapped ? fd.home_goals : fd.away_goals

      if game.finished?
        # Case 5: DB finished, FD not finished — surface as discrepancy.
        if fd.status != 'FINISHED'
          discrepancies << Discrepancy.new(
            game:      game,
            db_score:  [game.team1_goals, game.team2_goals],
            fd_score:  [fd_home_for_db, fd_away_for_db],
            fd_status: fd.status,
            duration:  fd.duration
          )
          return
        end

        # Case 3: already finished, same score → silent skip.
        # Case 4: already finished, different score → discrepancy.
        if game.team1_goals != fd_home_for_db || game.team2_goals != fd_away_for_db
          discrepancies << Discrepancy.new(
            game:      game,
            db_score:  [game.team1_goals, game.team2_goals],
            fd_score:  [fd_home_for_db, fd_away_for_db],
            fd_status: fd.status,
            duration:  fd.duration
          )
        end
        return
      end

      # game is NOT finished in our DB. Only act when FD reports FINISHED.
      return unless fd.status == 'FINISHED'

      # Case 2 (not finished, FD finished) and Case 6 (not finished, goals
      # manually set) both land here — silent overwrite is the agreed behaviour.
      ActiveRecord::Base.transaction do
        game.update!(
          team1_goals: fd_home_for_db,
          team2_goals: fd_away_for_db,
          finished:    true
        )
      end

      imported << ImportedGame.new(
        game:       game,
        home_goals: fd_home_for_db,
        away_goals: fd_away_for_db,
        duration:   fd.duration
      )
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Results::ImportFinishedGames: failed to update game #{game.id}: #{e.message}")
      # Per the per-game-transaction decision: never abort the whole batch.
    end

    # FD's `homeTeam` may correspond to our `team2` depending on how the
    # fixture was seeded. Detect by tla.
    def swapped?(game, fd)
      return false unless game.team1 && game.team2
      game.team1.football_data_tla == fd.away_tla && game.team2.football_data_tla == fd.home_tla
    end

    def recalculate_rankings
      ActiveRecord::Base.transaction do
        ::Tips::UpdatePoints.call
        ::Users::UpdatePoints.call
        ::Users::UpdateRankingPerGame.call
      end
    end

  end
end
