# frozen_string_literal: true

# Berechnet fuer alle beendeten Spiele alle Nutzer-Tipp-Punkte
module Tips
  class UpdatePoints < BaseService
    MAX_POINTS_PRO_TIP   = TipPoints::PERFECT
    POINTS_CORRECT_TREND = TipPoints::CORRECT_TREND
    EXTRA_POINT_GOALS    = 2
    EXTRA_POINT          = 1

    DRAW      = 0
    TEAM1_WIN = 1
    TEAM2_WIN = 2

    def call
      games = Game.all
      games.each do |game|
        if game.finished?
          Rails.logger.info("UPDATE_ALL_TIPP_POINTS: for game-id #{game.id}") if Rails.logger.present?
          update_all_tip_points_for(game)
        end
      end
    end

    private

    def update_all_tip_points_for(game)
      return if game.blank?

      game_winner = winner(game)

      return if game_winner.blank?

      tips = ::Tip.where(game_id: game.id)
      return if tips.blank?

      # mass-updating
      sql_when_values = []
      sql_where_all_ids = tips.map(&:id)

      tips.each do |tip|
        points = 0
        if tip.team1_goals.present? && tip.team2_goals.present?
          points = calculate_tip_points(game_winner,
                                        game.team1_goals, game.team2_goals,
                                        tip.team1_goals, tip.team2_goals)
        end
        sql_when_values << "WHEN id = #{tip.id} THEN #{points}"
      end
      sql = "UPDATE tips SET tip_points = CASE #{sql_when_values.join(' ')} END WHERE id IN (#{sql_where_all_ids.join(',')})"
      ::Tip.connection.execute(sql)
    end

    def calculate_tip_points(game_winner, game_team1_goals, game_team2_goals, tip_team1_goals, tip_team2_goals)
      points = 0
      points += POINTS_CORRECT_TREND if correct_trend?(game_winner, tip_team1_goals, tip_team2_goals)

      # nur wenn die Spieltendenz stimmt, gibt es auch die Punkte auf die richtige Toranzahl pro Team
      if points == POINTS_CORRECT_TREND
        points += EXTRA_POINT_GOALS if game_team1_goals == tip_team1_goals
        points += EXTRA_POINT_GOALS if game_team2_goals == tip_team2_goals
      end

      # 1 Punkt fuer richtige Tordifferenz
      goal_diff = tip_team1_goals - tip_team2_goals
      game_diff = game_team1_goals - game_team2_goals
      points += EXTRA_POINT if goal_diff == game_diff

      points
    end

    def correct_trend?(game_winner, tip_team1_goals, tip_team2_goals)
      (game_winner == DRAW && tip_team1_goals == tip_team2_goals) ||
        (game_winner == TEAM1_WIN && tip_team1_goals > tip_team2_goals) ||
        (game_winner == TEAM2_WIN && tip_team1_goals < tip_team2_goals)
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
