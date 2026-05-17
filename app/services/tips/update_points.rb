# frozen_string_literal: true

# Calculates tip points for all tips belonging to finished games.
#
# Bulk strategy (see Tips::UpdatePoints refactoring):
#   1. A single SELECT loads all tips for all finished games together with
#      the game result (TipQueries.all_tips_with_game_results_for_finished_games).
#   2. Points are computed in Ruby via calculate_tip_points (single source of truth).
#   3. Tips are grouped by computed point value; one UPDATE per distinct
#      point value is issued. This yields at most as many UPDATEs as there
#      are distinct point values (currently 6: 0, 1, 3, 4, 5, 8).
module Tips
  class UpdatePoints < BaseService
    MAX_POINTS_PRO_TIP   = TipPoints::PERFECT
    POINTS_CORRECT_TREND = TipPoints::CORRECT_TREND
    EXTRA_POINT_GOALS    = 2
    EXTRA_POINT          = 1

    DRAW      = 0
    TEAM1_WIN = 1
    TEAM2_WIN = 2

    def call
      rows = ::TipQueries.all_tips_with_game_results_for_finished_games
      return if rows.blank?

      ids_by_points = group_tip_ids_by_points(rows)

      ids_by_points.each do |points, tip_ids|
        # rubocop:disable Rails/SkipsModelValidations -- bulk perf update, no callbacks needed
        ::Tip.where(id: tip_ids).update_all(tip_points: points)
        # rubocop:enable Rails/SkipsModelValidations
      end
    end

    private

    def group_tip_ids_by_points(rows)
      result = Hash.new { |h, k| h[k] = [] }

      rows.each do |tip_id, tip_t1, tip_t2, game_t1, game_t2|
        points = points_for_row(tip_t1, tip_t2, game_t1, game_t2)
        result[points] << tip_id
      end

      result
    end

    def points_for_row(tip_t1, tip_t2, game_t1, game_t2)
      # Defense in depth: the bulk query already filters games with missing
      # goals, but a finished game without a recorded result must always be
      # skipped — matches the legacy winner(game) nil-guard.
      return 0 if game_t1.blank? || game_t2.blank?
      return 0 if tip_t1.blank? || tip_t2.blank?

      calculate_tip_points(winner_from_goals(game_t1, game_t2),
                           game_t1, game_t2, tip_t1, tip_t2)
    end

    def winner_from_goals(game_team1_goals, game_team2_goals)
      return TEAM1_WIN if game_team1_goals > game_team2_goals
      return TEAM2_WIN if game_team1_goals < game_team2_goals

      DRAW
    end

    def calculate_tip_points(game_winner, game_team1_goals, game_team2_goals, tip_team1_goals, tip_team2_goals)
      points = 0
      points += POINTS_CORRECT_TREND if correct_trend?(game_winner, tip_team1_goals, tip_team2_goals)

      # only when the trend (winner) is correct, award extra points for
      # correctly guessing the goal count of each team
      if points == POINTS_CORRECT_TREND
        points += EXTRA_POINT_GOALS if game_team1_goals == tip_team1_goals
        points += EXTRA_POINT_GOALS if game_team2_goals == tip_team2_goals
      end

      # 1 point for correct goal difference
      goal_diff = tip_team1_goals - tip_team2_goals
      game_diff = game_team1_goals - game_team2_goals
      points += EXTRA_POINT if goal_diff == game_diff

      points
    end

    def correct_trend?(game_winner, tip_team1_goals, tip_team2_goals)
      (game_winner == DRAW && tip_team1_goals == tip_team2_goals) ||
        (game_winner == TEAM1_WIN && tip_team1_goals > tip_team2_goals) ||
        (game_winner == TEAM2_WIN && tip_team1_goals < tip_team2_goals)
    end
  end
end
