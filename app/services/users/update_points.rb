# -*- encoding : utf-8 -*-

# Berechnet fuer alle Nutzer die Punkte (tipp_punkte)
#
# Speichern der Anzahl von
#   count_8points
#   count_5points
#   count_4points
#   count_3points
#   count_0points
module Users
  class UpdatePoints < BaseService

    CHAMPION_TIPP_POINTS = 8

    def call
      update_user_points
    end



    private

    def update_user_points
      users = User.active
      if users.present?
        users.each do |user|
          total_points  = Tipp.where(:user_id => user.id).sum(:tipp_punkte)
          total_points  = 0 unless total_points.present?

          champion_tipp_points = 0
          tournament_champion_team = get_tournament_champion_team
          champion_team_id     = tournament_champion_team.present? ? tournament_champion_team.id : nil
          if Tournament.finished? &&
              user.championtipp_team_id.present? &&
              user.championtipp_team_id == champion_team_id
            champion_tipp_points = CHAMPION_TIPP_POINTS
            total_points = total_points + champion_tipp_points
          end

          count_8points = Tipp.where({:user_id => user.id, :tipp_punkte => 8}).count
          count_5points = Tipp.where({:user_id => user.id, :tipp_punkte => 5}).count
          count_4points = Tipp.where({:user_id => user.id, :tipp_punkte => 4}).count
          count_3points = Tipp.where({:user_id => user.id, :tipp_punkte => 3}).count
          count_0points = Tipp.where({:user_id => user.id, :tipp_punkte => 0}).count

          user.update_columns({:points => total_points,
                               :championtipppoints => champion_tipp_points,
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