module Users
  class UpdateRankingPerGame < BaseService

    # FIXME soeren 19.09.15 specs
    def call
      finished_game_ids = ::GameQueries.all_finished_ordered_by_start_at.pluck(:id)
      all_8point_tips = TipQueries.all_by_game_ids_and_tip_points(finished_game_ids, 8)
      all_5point_tips = TipQueries.all_by_game_ids_and_tip_points(finished_game_ids, 5)
      all_4point_tips = TipQueries.all_by_game_ids_and_tip_points(finished_game_ids, 4)
      all_3point_tips = TipQueries.all_by_game_ids_and_tip_points(finished_game_ids, 3)
      used_game_ids = []

      finished_game_ids.each do |game_id|
        tips_for_game = TipQueries.all_by_game_id(game_id).select('id, user_id')
        used_game_ids << game_id

        user_id_and_sum_tip_points = TipQueries.sum_tip_points_group_by_user_id_by_game_ids(used_game_ids)

        user_id_and_ranking_comparison_value = user_id_and_sum_tip_points.map{ |user_id, sum_tip_points|
          count_8points = all_8point_tips.select{|tip| used_game_ids.include?(tip.game_id) && tip.user_id == user_id}.size
          count_5points = all_5point_tips.select{|tip| used_game_ids.include?(tip.game_id) && tip.user_id == user_id}.size
          count_4points = all_4point_tips.select{|tip| used_game_ids.include?(tip.game_id) && tip.user_id == user_id}.size
          count_3points = all_3point_tips.select{|tip| used_game_ids.include?(tip.game_id) && tip.user_id == user_id}.size

          str_points       = sum_tip_points.to_s.rjust(2,"0")
          str_count8points = count_8points.to_s.rjust(2,"0")
          str_count5points = count_5points.to_s.rjust(2,"0")
          str_count4points = count_4points.to_s.rjust(2,"0")
          str_count3points = count_3points.to_s.rjust(2,"0")

          # FIXME soeren 12.10.15 same in user.rb
          [user_id, "#{str_points}#{str_count8points}#{str_count5points}#{str_count4points}#{str_count3points}".to_i]
        }

        ordered_user_id_and_ranking_comparison_value = user_id_and_ranking_comparison_value.sort_by{|_, tip_points| tip_points}.reverse

        # FIXME soeren 19.09.15 same as in prepare_ranking.rb Service auslagern in gemeinsamen Service CallculateRanking
        result_for_this_game     = {}
        place                    = 1
        user_count_on_same_place = 1
        last_ranking_comparison_value = nil

        ordered_user_id_and_ranking_comparison_value.each do |user_id, ranking_comparison_value|
          if last_ranking_comparison_value.nil?
            # erste User
            result_for_this_game[place] = [user_id]
          else
            if last_ranking_comparison_value > ranking_comparison_value
              place = place + user_count_on_same_place
              result_for_this_game[place] = [user_id]
              user_count_on_same_place = 1
            elsif last_ranking_comparison_value == ranking_comparison_value
              user_id_on_same_place = result_for_this_game[place]
              result_for_this_game[place] = user_id_on_same_place + [user_id]
              user_count_on_same_place = user_count_on_same_place + 1
            else
              # no else
            end
          end
          last_ranking_comparison_value = ranking_comparison_value
        end

        # mass-updating
        sql_when_values = []
        sql_where_all_ids = []

        result_for_this_game.each do |ranking_place, user_ids|
          tip_ids = tips_for_game.select{|tip| tip.id if user_ids.include?(tip.user_id)}.map(&:id)

          tip_ids.each do |tip_id|
            sql_when_values << "WHEN id = #{tip_id} THEN #{ranking_place}"
          end
          sql_where_all_ids = sql_where_all_ids + tip_ids
        end

        sql = "UPDATE tips SET ranking_place = CASE #{sql_when_values.join(' ')} END WHERE id IN (#{sql_where_all_ids.join(',')})"
        ::Tip.connection.execute(sql)
      end

      true
    end
  end
end