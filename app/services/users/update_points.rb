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
          champion_team_id     = Game.tournament_champion_team.present? ? Game.tournament_champion_team.id : nil
          if Game.tournament_finished? &&
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

  end
end