# frozen_string_literal: true

module TipQueries
  class << self
    def all_ordered_by_tip_points_and_user_firstname_by_game_id(game_id)
      if game_id.present?
        Tip.where(game_id: game_id)
           .includes('user')
           .where('users.deleted_at' => nil)
           .order('tips.tip_points desc')
           .order('users.firstname asc')
      else
        []
      end
    end

    def all_by_game_id(game_id)
      Tip.where(game_id: game_id)
    end

    def all_by_games_and_tip_points(games, tip_points)
      Tip.where({ game_id: games, tip_points: tip_points })
         .select('id, user_id, game_id, tip_points')
    end

    def all_by_user_id_ordered_games_start_at(user_id)
      Tip.preload(game: %i[team1 team2]).joins(:game)
         .where(user_id: user_id).order('games.start_at asc')
    end

    def all_by_user_id_and_game_ids_ordered_games_start_at(user_id, game_ids)
      Tip.preload(game: %i[team1 team2]).joins(:game)
         .where(user_id: user_id).where(game_id: game_ids)
         .order('games.start_at asc')
    end

    def all_by_user_id_and_tip_points(user_id, tip_points)
      Tip.where({ user_id: user_id, tip_points: tip_points })
    end

    def exists_for_user_id?(user_id)
      Tip.exists?(user_id: user_id)
    end

    def sum_tip_points_by_user_id(user_id)
      Tip.where(user_id: user_id).sum(:tip_points)
    end

    def sum_tip_points_group_by_user_id_by_game_ids(game_ids)
      Tip.where(game_id: game_ids).group(:user_id).sum(:tip_points)
    end

    # Returns a hash: { user_id => total_tip_points } for ALL tips (no filter).
    # Single query replacing N individual sum_tip_points_by_user_id calls.
    def sum_tip_points_grouped_by_user_id
      Tip.group(:user_id).sum(:tip_points)
    end

    # Returns a nested hash: { user_id => { tip_points => count } }
    # Single query replacing N×5 individual all_by_user_id_and_tip_points count calls.
    def counts_by_user_id_and_tip_points(point_values)
      rows = Tip.where(tip_points: point_values).group(:user_id, :tip_points).count
      result = Hash.new { |h, k| h[k] = Hash.new(0) }
      rows.each { |(uid, pts), cnt| result[uid][pts] = cnt }
      result
    end

    # Returns an array of [tip_id, tip_team1_goals, tip_team2_goals,
    #                      game_team1_goals, game_team2_goals] rows for every
    # tip belonging to a finished game whose result is fully recorded.
    # Single query replacing the per-finished-game SELECT loop in
    # Tips::UpdatePoints.
    #
    # Games are filtered to those with both team1_goals and team2_goals set,
    # because admins can mark a game finished without entering goals — those
    # games must be skipped (matches the legacy `winner(game)` nil-guard).
    def all_tips_with_game_results_for_finished_games
      Tip.joins(:game)
         .where(games: { finished: true })
         .where.not(games: { team1_goals: nil })
         .where.not(games: { team2_goals: nil })
         .pluck(:id, :team1_goals, :team2_goals,
                'games.team1_goals', 'games.team2_goals')
    end
  end
end
