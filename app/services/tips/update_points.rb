# -*- encoding : utf-8 -*-

# Berechnet fuer alle beendeten Spiele alle Nutzer-Tipp-Punkte
module Tips
  class UpdatePoints < BaseService

    MAX_POINTS_PRO_TIP   = 8
    POINTS_CORRECT_TREND = 3
    EXTRA_POINT_GOALS    = 2
    EXTRA_POINT          = 1

    DRAW      = 0
    TEAM1_WIN = 1
    TEAM2_WIN = 2

    def call
      update_all_user_tip_points
    end



    private

    def update_all_user_tip_points
      games = Game.all
      games.each do |game|
        if game.finished?
          update_all_tip_points_for(game)
        end
      end
    end

    def update_all_tip_points_for(game)
      if game.present?
        game_winner = winner(game)

        if game_winner.present?
          Rails.logger.info("UPDATE_ALL_TIPP_POINTS: for game-id #{game.id}") if Rails.logger.present?
          tips = Tip.where(:game_id => game.id)
          if tips.present?
            tips.each do |tip|
              points = 0
              if tip.team1_goals.present? && tip.team2_goals.present?
                points = calculate_tip_points(game_winner, game.team1_goals, game.team2_goals, tip.team1_goals, tip.team2_goals)
              end
              tip.update_column(:tip_points, points)
              Rails.logger.info("UPDATE_ALL_TIPP_POINTS:   tip-id #{tip.id} has #{points} points") if Rails.logger.present?
            end
          end
        end
      end
    end

    def calculate_tip_points(game_winner, game_team1_goals, game_team2_goals, tip_team1_goals, tip_team2_goals)
      points = 0
      if (DRAW == game_winner && tip_team1_goals == tip_team2_goals) ||
          (TEAM1_WIN == game_winner && tip_team1_goals > tip_team2_goals) ||
          (TEAM2_WIN == game_winner && tip_team1_goals < tip_team2_goals)
        points = points + POINTS_CORRECT_TREND
      end

      # nur wenn die Spieltendenz stimmt, gibt es auch die Punkte auf die richtige Toranzahl pro Team
      if POINTS_CORRECT_TREND == points
        points = points + EXTRA_POINT_GOALS if game_team1_goals == tip_team1_goals
        points = points + EXTRA_POINT_GOALS if game_team2_goals == tip_team2_goals
      end

      # 1 Punkt fuer richtige Tordifferenz
      goal_diff = tip_team1_goals - tip_team2_goals
      game_diff = game_team1_goals - game_team2_goals
      points = points + EXTRA_POINT if goal_diff == game_diff

      points
    end

    # wer hat gewonnen Team1 oder Team2, unentschieden == 0
    def winner(game)
      result = nil
      if game.team1_goals.present? && game.team2_goals.present?
        result = TEAM1_WIN if game.team1_goals > game.team2_goals
        result = TEAM2_WIN if game.team1_goals < game.team2_goals
        result = DRAW if game.team1_goals == game.team2_goals
      end

      result
    end


  end
end