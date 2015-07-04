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

    CHAMPION_TIP_POINTS = 8

    def call
      update_user_points
    end



    private

    def update_user_points
      users = User.active
      if users.present?
        users.each do |user|
          total_points  = Tip.where(:user_id => user.id).sum(:tip_points)
          total_points  = 0 unless total_points.present?

          champion_tip_points = 0
          tournament_champion_team = get_tournament_champion_team
          champion_team_id     = tournament_champion_team.present? ? tournament_champion_team.id : nil
          if Tournament.finished? &&
              user.championtip_team_id.present? &&
              user.championtip_team_id == champion_team_id
            champion_tip_points = CHAMPION_TIP_POINTS
            total_points = total_points + champion_tip_points
          end

          count_8points = Tip.where({:user_id => user.id, :tip_points => 8}).count
          count_5points = Tip.where({:user_id => user.id, :tip_points => 5}).count
          count_4points = Tip.where({:user_id => user.id, :tip_points => 4}).count
          count_3points = Tip.where({:user_id => user.id, :tip_points => 3}).count
          count_0points = Tip.where({:user_id => user.id, :tip_points => 0}).count

          user.update_columns({:points => total_points,
                               :championtippoints => champion_tip_points,
                               :count8points => count_8points,
                               :count5points => count_5points,
                               :count4points => count_4points,
                               :count3points => count_3points,
                               :count0points => count_0points,
                              })
          Rails.logger.info("CALCULATE_USER_POINTS: #{user.name} - totalpoints: #{total_points}") if Rails.logger.present?
        end
      end
    end

    def get_tournament_champion_team
      result = nil
      games = ::Game.final_games
      if games.present?
        result = winner_team(games.first)
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



  end
end