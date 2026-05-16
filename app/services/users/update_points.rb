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

    BONUS_TIP_POINTS = TipPoints::BONUS

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
      return unless users.present?

      # Two bulk queries replace N×6 individual queries.
      points_by_user   = ::TipQueries.sum_tip_points_grouped_by_user_id
      counts_by_user   = ::TipQueries.counts_by_user_id_and_tip_points(TipPoints::ALL_VALUES)
      tournament_done  = Tournament.finished?

      users.each do |user|
        tip_points    = points_by_user[user.id] || 0
        user_counts   = counts_by_user[user.id]

        bonus_tips_points = 0
        if tournament_done
          bonus_tips_points = calculate_bonus_points(user)
          tip_points        = tip_points + bonus_tips_points
        end

        user.update_columns({
          points:       tip_points,
          bonus_points: bonus_tips_points,
          count8points: user_counts[TipPoints::PERFECT],
          count5points: user_counts[TipPoints::CORRECT_GOALS_ONE_TEAM],
          count4points: user_counts[TipPoints::CORRECT_GOALS],
          count3points: user_counts[TipPoints::CORRECT_TREND],
          count0points: user_counts[TipPoints::NO_POINTS],
        })
        Rails.logger.debug("CALCULATE_USER_POINTS: #{user.name} - total points: #{tip_points}") if Rails.logger.present?
      end
    end
  end
end