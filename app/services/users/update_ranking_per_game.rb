# frozen_string_literal: true

module Users
  class UpdateRankingPerGame < UserBaseService
    # Per-game ranking algorithm.
    #
    # Bulk strategy (see refactoring):
    #   - Cumulative per-user counts (8/5/4/3 point tips AND total tip points)
    #     are maintained in Ruby, no SQL per game.
    #   - ranking_place values are collected across all games and written in
    #     a few UPDATEs at the end (grouped by ranking_place value).
    def call
      finished_games = ::GameQueries.all_finished_ordered_by_start_at_with_preload_tips
      return true if finished_games.blank?

      indexes = build_indexes(finished_games)
      tip_id_to_place = compute_tip_id_to_place(finished_games, indexes)
      bulk_update_ranking_places(tip_id_to_place)

      true
    end

    private

    def build_indexes(finished_games)
      {
        i8: build_game_user_index(::TipQueries.all_by_games_and_tip_points(finished_games, TipPoints::PERFECT)),
        i5: build_game_user_index(::TipQueries.all_by_games_and_tip_points(finished_games, TipPoints::CORRECT_GOALS_ONE_TEAM)),
        i4: build_game_user_index(::TipQueries.all_by_games_and_tip_points(finished_games, TipPoints::CORRECT_GOALS)),
        i3: build_game_user_index(::TipQueries.all_by_games_and_tip_points(finished_games, TipPoints::CORRECT_TREND))
      }
    end

    # Walks the games in start_at order, maintains cumulative per-user counts
    # in-memory, and accumulates a flat tip_id => ranking_place mapping for a
    # single bulk update at the end.
    def compute_tip_id_to_place(finished_games, indexes) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity -- algorithm intrinsic complexity
      cum_points = Hash.new(0)
      cum_8 = Hash.new(0) # rubocop:disable Naming/VariableNumber
      cum_5 = Hash.new(0) # rubocop:disable Naming/VariableNumber
      cum_4 = Hash.new(0) # rubocop:disable Naming/VariableNumber
      cum_3 = Hash.new(0) # rubocop:disable Naming/VariableNumber

      tip_id_to_place = {}

      finished_games.each do |game|
        # Increment cumulative counters from the preloaded tips of THIS game.
        # No SQL: tips are already loaded by all_finished_ordered_by_start_at_with_preload_tips.
        game.tips.each { |tip| cum_points[tip.user_id] += tip.tip_points.to_i }
        (indexes[:i8][game.id] || []).each { |uid| cum_8[uid] += 1 }
        (indexes[:i5][game.id] || []).each { |uid| cum_5[uid] += 1 }
        (indexes[:i4][game.id] || []).each { |uid| cum_4[uid] += 1 }
        (indexes[:i3][game.id] || []).each { |uid| cum_3[uid] += 1 }

        ordered = ordered_users_for_game(cum_points, cum_8, cum_5, cum_4, cum_3)
        places_for_game = assign_places(ordered)

        # Map this game's tips to ranking_place via user_id lookup.
        place_by_user_id = invert_to_user_id(places_for_game)
        game.tips.each do |tip|
          place = place_by_user_id[tip.user_id]
          tip_id_to_place[tip.id] = place if place
        end
      end

      tip_id_to_place
    end

    def ordered_users_for_game(cum_points, cum_8, cum_5, cum_4, cum_3) # rubocop:disable Naming/VariableNumber
      with_rcv = cum_points.keys.map do |uid|
        [uid,
         ranking_comparison_value(cum_points[uid], cum_8[uid], cum_5[uid], cum_4[uid], cum_3[uid]).to_i]
      end
      with_rcv.sort_by { |_, rcv| -rcv }
    end

    # Returns { ranking_place => [user_id, ...] } using standard-competition
    # ranking (1, 2, 2, 4).
    def assign_places(ordered_user_id_and_rcv)
      result = {}
      place = 1
      user_count_on_same_place = 1
      last_rcv = nil

      ordered_user_id_and_rcv.each do |user_id, rcv|
        if last_rcv.nil?
          result[place] = [user_id]
        elsif last_rcv > rcv
          place += user_count_on_same_place
          result[place] = [user_id]
          user_count_on_same_place = 1
        elsif last_rcv == rcv
          result[place] += [user_id]
          user_count_on_same_place += 1
        end
        last_rcv = rcv
      end

      result
    end

    def invert_to_user_id(places_for_game)
      result = {}
      places_for_game.each do |place, user_ids|
        user_ids.each { |uid| result[uid] = place }
      end
      result
    end

    # Builds { game_id => [user_id, ...] } from a flat tip collection.
    def build_game_user_index(tips)
      tips.each_with_object(Hash.new { |h, k| h[k] = [] }) do |tip, idx|
        idx[tip.game_id] << tip.user_id
      end
    end

    # Group tip_ids by ranking_place value and emit one UPDATE per distinct
    # place. Worst case = number of distinct ranking_place values across all
    # games (bounded by number of users) — but tiny SQL packets and PK-only
    # WHERE clauses, so each statement is fast.
    def bulk_update_ranking_places(tip_id_to_place)
      return if tip_id_to_place.empty?

      ids_by_place = Hash.new { |h, k| h[k] = [] }
      tip_id_to_place.each { |tip_id, place| ids_by_place[place] << tip_id }

      ids_by_place.each do |place, tip_ids|
        # rubocop:disable Rails/SkipsModelValidations -- bulk perf update, no callbacks needed
        ::Tip.where(id: tip_ids).update_all(ranking_place: place)
        # rubocop:enable Rails/SkipsModelValidations
      end
    end
  end
end
