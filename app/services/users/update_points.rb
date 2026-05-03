# -*- encoding : utf-8 -*-

# Berechnet fuer alle Nutzer die Punkte (tip_points)
#
# Speichern der Anzahl von
#   count_8points
#   count_5points
#   count_4points
#   count_3points
#   count_0points
module Users
  class UpdatePoints < BaseService

    BONUS_TIP_POINTS = 8

    def call
      update_user_points
    end


    private

    def calculate_bonus_points(user)
      result = 0
      if Tournament.finished?
        if user.bonus_champion_team_id.present?
          result += BONUS_TIP_POINTS if tournament_champion&.id == user.bonus_champion_team_id
        end

        if user.bonus_second_team_id.present?
          result += BONUS_TIP_POINTS if tournament_second&.id == user.bonus_second_team_id
        end

        if user.bonus_when_final_first_goal.present?
          result += BONUS_TIP_POINTS if bonus_when_first_goal_answer.present? && user.bonus_when_final_first_goal == bonus_when_first_goal_answer
        end

        if user.bonus_how_many_goals.present?
          result += BONUS_TIP_POINTS if bonus_how_many_goals_answer.present? && user.bonus_how_many_goals == bonus_how_many_goals_answer
        end
      end

      result
    end

    def tournament_champion
      @tournament_champion ||= ::GameQueries.tournament_champion_team
    end

    def tournament_second
      @tournament_second ||= ::GameQueries.tournament_second_team
    end

    def bonus_when_first_goal_answer
      @bonus_when_first_goal_answer ||= AppSetting.bonus_answer_when_will_the_first_goal
    end

    def bonus_how_many_goals_answer
      @bonus_how_many_goals_answer ||= AppSetting.bonus_answer_how_many_goals
    end

    def update_user_points
      users = User.active
      if users.present?
        users.each do |user|
          total_points  = ::TipQueries.sum_tip_points_by_user_id(user.id)
          total_points  = 0 unless total_points.present?

          bonus_tips_points = 0
          if Tournament.finished?
            bonus_tips_points = calculate_bonus_points(user)
            total_points = total_points + bonus_tips_points
          end

          count_8points = ::TipQueries.all_by_user_id_and_tip_points(user.id, 8).count
          count_5points = ::TipQueries.all_by_user_id_and_tip_points(user.id, 5).count
          count_4points = ::TipQueries.all_by_user_id_and_tip_points(user.id, 4).count
          count_3points = ::TipQueries.all_by_user_id_and_tip_points(user.id, 3).count
          count_0points = ::TipQueries.all_by_user_id_and_tip_points(user.id, 0).count

          user.update_columns({:points => total_points,
                               :bonus_points => bonus_tips_points,
                               :count8points => count_8points,
                               :count5points => count_5points,
                               :count4points => count_4points,
                               :count3points => count_3points,
                               :count0points => count_0points,
                              })
          Rails.logger.debug("CALCULATE_USER_POINTS: #{user.name} - total points: #{total_points}") if Rails.logger.present?
        end
      end
    end
  end
end