# frozen_string_literal: true

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
      return 0 unless Tournament.finished?

      [
        bonus_champion_correct?(user),
        bonus_second_correct?(user),
        bonus_first_goal_correct?(user),
        bonus_how_many_goals_correct?(user)
      ].count(true) * BONUS_TIP_POINTS
    end

    def bonus_champion_correct?(user)
      user.bonus_champion_team_id.present? && tournament_champion&.id == user.bonus_champion_team_id
    end

    def bonus_second_correct?(user)
      user.bonus_second_team_id.present? && tournament_second&.id == user.bonus_second_team_id
    end

    def bonus_first_goal_correct?(user)
      user.bonus_when_final_first_goal.present? &&
        bonus_when_first_goal_answer.present? &&
        user.bonus_when_final_first_goal == bonus_when_first_goal_answer
    end

    def bonus_how_many_goals_correct?(user)
      user.bonus_how_many_goals.present? &&
        bonus_how_many_goals_answer.present? &&
        user.bonus_how_many_goals == bonus_how_many_goals_answer
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

    def update_user_points # rubocop:disable Metrics/MethodLength -- bulk update logic with per-user calculation, splitting would harm locality
      users = User.active
      return if users.blank?

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
          tip_points += bonus_tips_points
        end

        user.update_columns({ # rubocop:disable Rails/SkipsModelValidations -- intentional: bulk perf update, no callbacks needed
                              points: tip_points,
                              bonus_points: bonus_tips_points,
                              count8points: user_counts[TipPoints::PERFECT],
                              count5points: user_counts[TipPoints::CORRECT_GOALS_ONE_TEAM],
                              count4points: user_counts[TipPoints::CORRECT_GOALS],
                              count3points: user_counts[TipPoints::CORRECT_TREND],
                              count0points: user_counts[TipPoints::NO_POINTS]
                            })
        next if Rails.logger.blank?

        Rails.logger.debug do
          "CALCULATE_USER_POINTS: #{user.name} - total points: #{tip_points}"
        end
      end
    end
  end
end
