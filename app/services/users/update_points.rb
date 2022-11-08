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
      # todo test it
      result = 0
      if Tournament.finished?
        if user.bonus_champion_team_id.present?
          tournament_champion_team = get_tournament_champion_team
          bonus_champion_team_id = tournament_champion_team.present? ? tournament_champion_team.id : nil
          result += BONUS_TIP_POINTS if user.bonus_champion_team_id == bonus_champion_team_id
        end

        if user.bonus_second_team_id.present?
          tournament_second_team = get_tournament_second_team
          bonus_second_team_id = tournament_second_team.present? ? tournament_second_team.id : nil
          result += BONUS_TIP_POINTS if user.bonus_second_team_id == bonus_second_team_id
        end

        if user.bonus_when_final_first_goal.present?
          # todo #212 how to store in the admin when the first final goal was scored
        end

        if user.bonus_how_many_goals.present?
          # todo #212 how to store max goals in the admin - new DB table
        end
      end

      result
    end

    def update_user_points
      users = User.active
      if users.present?
        users.each do |user|
          total_points  = ::TipQueries.sum_tip_points_by_user_id(user.id)
          total_points  = 0 unless total_points.present?

          bonus_tips_points = calculate_bonus_points(user)
          if Tournament.finished?
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

    def get_tournament_champion_team
      result = nil
      final_game = ::GameQueries.final_game
      if final_game.present?
        result = winner_team(final_game)
      end

      result
    end

    def get_tournament_second_team
      result = nil
      final_game = ::GameQueries.final_game
      if final_game.present?
        result = looser_team(final_game)
      end

      result
    end

    # bei Unentschieden wird nil geliefert ansonsten, das Siegerteam
    def winner_team(game)
      result = nil
      if game.team1_goals.present? && game.team2_goals.present?
        result = game.team1 if game.team1_goals > game.team2_goals
        result = game.team2 if game.team1_goals < game.team2_goals
      end

      result
    end

    def looser_team(game)
      result = nil
      if game.team1_goals.present? && game.team2_goals.present?
        result = game.team1 if game.team1_goals < game.team2_goals
        result = game.team2 if game.team1_goals > game.team2_goals
      end

      result
    end


  end
end