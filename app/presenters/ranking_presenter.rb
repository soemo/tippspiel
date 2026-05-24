# frozen_string_literal: true

class RankingPresenter
  def initialize(current_user)
    @current_user = current_user
  end

  def bonus_answers_visible?
    @bonus_answers_visible ||= Tournament.round_of_16_started?
  end

  def finished_games_count
    @finished_games_count ||= GameQueries.finished.count
  end

  def all_games_count
    @all_games_count ||= Game.count
  end

  def user_count
    @user_count ||= User.active.count
  end

  def user_ranking_hash
    @user_ranking_hash ||= begin
      user_ranking = Users::PrepareRanking.call(users_for_ranking: ::UserQueries.all_ordered_by_points_and_all_countxpoints)
      user_ranking.sort
    end
  end

  def bonus_ranking_info(user, for_small_screen: false)
    return '' unless bonus_answers_visible?

    flag_size = for_small_screen ? 16 : 32
    [
      team_flag_or_dash(user.bonus_champion_team, flag_size),
      team_flag_or_dash(user.bonus_second_team, flag_size),
      first_goal_label(user),
      user.bonus_how_many_goals.presence || '-'
    ].join(' | ')
  end

  def bonus_hint_for?(user)
    return false if bonus_answers_visible?
    return false unless @current_user&.id == user.id

    !@current_user.all_bonus_questions_filled_out?
  end

  private

  def team_flag_or_dash(team, flag_size)
    return '-' unless team

    TeamPresenter.new(team).teamflag(flag_size)
  end

  def first_goal_label(user)
    return '-' if user.bonus_when_final_first_goal.blank?

    option = BONUS_OPTIONS_WHEN_WILL_THE_FIRST_GOAL[user.bonus_when_final_first_goal]
    I18n.t("bonus_questions.when_final_first_goal_options.#{option}_short")
  end
end
