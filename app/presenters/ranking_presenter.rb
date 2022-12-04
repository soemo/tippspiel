class RankingPresenter

  def initialize

  end

  def bonus_answers_visible?
    Tournament.round_of_16_started?
  end

  def bonus_ranking_info(user, for_small_screen = false)
    result = []

    if bonus_answers_visible?
      flag_size = for_small_screen ? 16 : 32

      if user.bonus_champion_team_id.present?
        champteam_presenter = TeamPresenter.new(user.bonus_champion_team)
        result << champteam_presenter.teamflag(flag_size)
      else
        result << '-'
      end

      if user.bonus_second_team_id.present?
        secondteam_presenter = TeamPresenter.new(user.bonus_second_team)
        result << secondteam_presenter.teamflag(flag_size)
      else
        result << '-'
      end

      if user.bonus_when_final_first_goal.present?
        option = BONUS_OPTIONS_WHEN_WILL_THE_FIRST_GOAL[user.bonus_when_final_first_goal]
        result << I18n.t("bonus_questions.when_final_first_goal_options.#{option}_short")
      else
        result << '-'
      end

      if user.bonus_how_many_goals.present?
        result << user.bonus_how_many_goals
      else
        result << '-'
      end

      result = result.join(' | ')
    else
      result = I18n.t('ranking_bonus_answers_currently_not_visible')
    end

    result
  end

  def finished_games_count
    GameQueries.finished.count
  end

  def all_games_count
    Game.count
  end

  def user_count
    User.active.count
  end

  def user_ranking_hash
    user_ranking = Users::PrepareRanking.call(users_for_ranking: ::UserQueries.all_ordered_by_points_and_all_countxpoints)
    user_ranking.sort
  end

end