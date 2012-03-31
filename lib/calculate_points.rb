# berechnet für alle Nutzer die Tipp-Punkte

module CalculatePoints

  # FIXME soeren 03.01.12 implement - Aufruf in schedulerController
  MAX_POINTS_PRO_TIPP  = 6
  POINTS_CORRECT_TREND = 3
  EXTRA_POINT          = 1
  CHAMPION_TIPP_POINTS = 6

  def calculate_user_points
    users = User.all
    if users.present?
      users.each do |user|
        total_points  = Tipp.where(:user_id => user.id).sum(:tipp_punkte)
        total_points  = 0 unless total_points.present?

        champion_tipp_points = 0
        if Game.tournament_finished? &&
                user.championtipp_team_id.present? &&
                user.championtipp_team_id == Game.tournament_champion_team.id
          champion_tipp_points = CHAMPION_TIPP_POINTS
          total_points = total_points + champion_tipp_points
        end

        count_6points = Tipp.where({:user_id => user.id, :tipp_punkte => 6}).count
        count_4points = Tipp.where({:user_id => user.id, :tipp_punkte => 4}).count
        count_3points = Tipp.where({:user_id => user.id, :tipp_punkte => 3}).count
        count_0points = Tipp.where({:user_id => user.id, :tipp_punkte => 0}).count

        user.update_attributes({:points => total_points,
                                :championtipppoints => champion_tipp_points,
                                :count6points => count_6points,
                                :count4points => count_4points,
                                :count3points => count_3points,
                                :count0points => count_0points,
                               }, {:without_protection => true})
      end
    end
  end

  def calculate_all_user_tipp_points
    games = Game.all
    games.each do |game|
      if game.finished?
        update_all_tipp_points_for(game)
      end
    end

  end

  def update_all_tipp_points_for(game)
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
            (Game::TEAM2_WIN == game_winner && tipp_team1_goals < tipp_team2_goals))
      points = points + POINTS_CORRECT_TREND
    end

    # nur wenn die Spieltendenz stimmt, gibt es auch die Punkte auf die richtige Toranzahl pro Team
    if POINTS_CORRECT_TREND == points
      points = points + EXTRA_POINT if game_team1_goals == tipp_team1_goals
      points = points + EXTRA_POINT if game_team2_goals == tipp_team2_goals
    end

    # 1 Punkt fuer richtige Tordifferenz
    goal_diff = tipp_team1_goals - tipp_team2_goals
    game_diff = game_team1_goals - game_team2_goals
    points = points + EXTRA_POINT if goal_diff == game_diff

    points
  end

end