# frozen_string_literal: true

module Users
  class UpdateRankingPerGame < UserBaseService
    def call # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity -- per-game ranking algorithm; complexity is intrinsic to the place-assignment logic
      finished_games  = ::GameQueries.all_finished_ordered_by_start_at_with_preload_tips
      all_8point_tips = ::TipQueries.all_by_games_and_tip_points(finished_games, TipPoints::PERFECT)
      all_5point_tips = ::TipQueries.all_by_games_and_tip_points(finished_games, TipPoints::CORRECT_GOALS_ONE_TEAM)
      all_4point_tips = ::TipQueries.all_by_games_and_tip_points(finished_games, TipPoints::CORRECT_GOALS)
      all_3point_tips = ::TipQueries.all_by_games_and_tip_points(finished_games, TipPoints::CORRECT_TREND)

      # Pre-build lookup hashes: { game_id => Set<user_id> }
      # O(1) membership check instead of scanning the full array each iteration.
      index_8 = build_game_user_index(all_8point_tips) # rubocop:disable Naming/VariableNumber
      index_5 = build_game_user_index(all_5point_tips) # rubocop:disable Naming/VariableNumber
      index_4 = build_game_user_index(all_4point_tips) # rubocop:disable Naming/VariableNumber
      index_3 = build_game_user_index(all_3point_tips) # rubocop:disable Naming/VariableNumber

      # Cumulative per-user counts that grow as we walk through games in order.
      cum_8 = Hash.new(0) # rubocop:disable Naming/VariableNumber
      cum_5 = Hash.new(0) # rubocop:disable Naming/VariableNumber
      cum_4 = Hash.new(0) # rubocop:disable Naming/VariableNumber
      cum_3 = Hash.new(0) # rubocop:disable Naming/VariableNumber
      used_game_ids = []

      finished_games.each do |game|
        tips_for_game  = game.tips
        used_game_ids << game.id

        # Increment only the users who scored on this specific game — O(users_in_game).
        (index_8[game.id] || []).each { |uid| cum_8[uid] += 1 }
        (index_5[game.id] || []).each { |uid| cum_5[uid] += 1 }
        (index_4[game.id] || []).each { |uid| cum_4[uid] += 1 }
        (index_3[game.id] || []).each { |uid| cum_3[uid] += 1 }

        ordered_user_id_and_ranking_comparison_value =
          get_ordered_user_id_and_ranking_comparison_value(cum_8, cum_5, cum_4, cum_3, used_game_ids)

        result_for_this_game     = {}
        place                    = 1
        user_count_on_same_place = 1
        last_ranking_comparison_value = nil

        ordered_user_id_and_ranking_comparison_value.each do |user_id, ranking_comparison_value|
          if last_ranking_comparison_value.nil?
            # erste User
            result_for_this_game[place] = [user_id]
          elsif last_ranking_comparison_value > ranking_comparison_value
            place += user_count_on_same_place
            result_for_this_game[place] = [user_id]
            user_count_on_same_place = 1
          elsif last_ranking_comparison_value == ranking_comparison_value
            user_id_on_same_place = result_for_this_game[place]
            result_for_this_game[place] = user_id_on_same_place + [user_id]
            user_count_on_same_place += 1
          end
          last_ranking_comparison_value = ranking_comparison_value
        end

        mass_updating_tips(result_for_this_game, tips_for_game)
      end

      true
    end

    private

    # Builds { game_id => [user_id, ...] } from a flat tip collection.
    def build_game_user_index(tips)
      tips.each_with_object(Hash.new { |h, k| h[k] = [] }) do |tip, idx|
        idx[tip.game_id] << tip.user_id
      end
    end

    def get_ordered_user_id_and_ranking_comparison_value(cum_8, cum_5, cum_4, cum_3, used_game_ids) # rubocop:disable Naming/VariableNumber
      user_id_and_sum_tip_points = TipQueries.sum_tip_points_group_by_user_id_by_game_ids(used_game_ids)

      user_id_and_ranking_comparison_value = user_id_and_sum_tip_points.map do |user_id, sum_tip_points|
        [user_id,
         ranking_comparison_value(sum_tip_points, cum_8[user_id], cum_5[user_id], cum_4[user_id], cum_3[user_id]).to_i]
      end

      user_id_and_ranking_comparison_value.sort_by { |_, tip_points| tip_points }.reverse
    end

    def mass_updating_tips(result_for_this_game, tips_for_game)
      sql_when_values = []
      sql_where_all_ids = []

      result_for_this_game.each do |ranking_place, user_ids|
        tip_ids = tips_for_game.select { |tip| tip.id if user_ids.include?(tip.user_id) }.map(&:id)

        tip_ids.each do |tip_id|
          sql_when_values << "WHEN id = #{tip_id} THEN #{ranking_place}"
        end
        sql_where_all_ids += tip_ids
      end

      sql = "UPDATE tips SET ranking_place = CASE #{sql_when_values.join(' ')} END WHERE id IN (#{sql_where_all_ids.join(',')})"
      ::Tip.connection.execute(sql)
    end
  end
end
