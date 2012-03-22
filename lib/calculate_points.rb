# berechnet für alle Nutzer die Tipp-Punkte

module CalculatePoints

  # FIXME soeren 03.01.12 implement - Aufruf in schedulerController
  POINTS_CORRECT_TREND = 3
  EXTRA_POINT          = 1

  def calculate_all_user_tipp_points
    games = Game.all
    games.each do |game|
      if game.finished?
        update_all_tipp_points_for_game(game)
      end
    end

  end

  def update_all_tipp_points_for_game(game)
    if game.present?
      new_points = 0
      game_winner = game.winner

      if game_winner.present?
        tipps = Tipp.where(:game_id => game.id).all
        if tipps.present?
          tipps.each do |tipp|
            if tipp.complete_fill?
              points = calculate_tipp_points(game_winner, game.team1_goals, game.team2_goals, tipp.team1_goals, tipp.team2_goals)
              tipp.update_attribute(:tipp_punkte, points)
            end
          end
        end
      end
    end
  end

  def calculate_tipp_points(game_winner, game_team1_goals, game_team2_goals, tipp_team1_goals, tipp_team2_goals)
    points = 0
    if ((Game::UNENTSCHIEDEN == game_winner && tipp_team1_goals == tipp_team2_goals) ||
            (Game::TEAM1_WIN == game_winner && tipp_team1_goals > tipp_team2_goals) ||
            (Game::TEAM1_WIN == game_winner && tipp_team1_goals > tipp_team2_goals))
      new_points = points + POINTS_CORRECT_TREND
    end

    #nur wenn die Spieltendenz stimmt, gibt es auch die Punkte auf die richtige Toranzahl pro Team
    if POINTS_CORRECT_TREND == points
      new_points = points + EXTRA_POINT if game_team1_goals == tipp_team1_goals
      new_points = points + EXTRA_POINT if game_team2_goals == tipp_team2_goals
    end

    #1 Punkt fuer richtige Tordifferenz
    goal_diff = tipp_team1_goals - tipp_team2_goals
    game_diff = game_team1_goals - game_team2_goals
    points = points + EXTRA_POINT if goal_diff == game_diff

    points
  end

end