# frozen_string_literal: true

class BonusEditPresenter
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def bonus_champion_team
    current_user.present? ? current_user.bonus_champion_team : nil
  end

  def bonus_champion_team_id
    bonus_champion_team.present? ? bonus_champion_team.id : ''
  end

  def champion_team_with_flag
    champ_team = bonus_champion_team
    if champ_team.present?
      TeamPresenter.new(champ_team).team_name_with_flag
    else
      I18n.t('no_champion_tip')
    end
  end

  def bonus_second_team
    current_user.present? ? current_user.bonus_second_team : nil
  end

  def bonus_second_team_id
    bonus_second_team.present? ? bonus_second_team.id : ''
  end

  def second_team_with_flag
    team = bonus_second_team
    if team.present?
      TeamPresenter.new(team).team_name_with_flag
    else
      I18n.t('no_second_tip')
    end
  end

  def bonus_when_final_first_goal
    current_user.present? ? current_user.bonus_when_final_first_goal : nil
  end

  def bonus_when_final_first_goal_answer
    selection = bonus_when_final_first_goal
    if selection.present?
      I18n.t("bonus_questions.when_final_first_goal_options.#{BONUS_OPTIONS_WHEN_WILL_THE_FIRST_GOAL[selection]}")
    else
      I18n.t('no_when_first_goal_tip')
    end
  end

  def bonus_how_many_goals
    current_user.present? ? current_user.bonus_how_many_goals : nil
  end

  def bonus_how_many_goals_answer
    selection = bonus_how_many_goals
    if selection.present?
      bonus_how_many_goals
    else
      I18n.t('no_how_many_goals_tip')
    end
  end

  def options_for_team_tip_select
    TeamQueries.all_ordered_by_name.map { |t| [TeamPresenter.new(t).translated_name, t.id] }
  end

  def options_for_when_final_first_goal_select
    BONUS_OPTIONS_WHEN_WILL_THE_FIRST_GOAL.map do |v|
      [I18n.t("bonus_questions.when_final_first_goal_options.#{v[1]}"), v[0]]
    end
  end

  def round_of_16_name
    I18n.t('round.roundof16')
  end

  # --- bonus result methods (only meaningful after Tournament.finished?) ---

  def bonus_points
    current_user.present? ? current_user.bonus_points.to_i : 0
  end

  def champion_correct?
    return false unless Tournament.finished? && bonus_champion_team.present?

    champion = GameQueries.tournament_champion_team
    champion.present? && bonus_champion_team.id == champion.id
  end

  def second_correct?
    return false unless Tournament.finished? && bonus_second_team.present?

    second = GameQueries.tournament_second_team
    second.present? && bonus_second_team.id == second.id
  end

  def when_first_goal_correct?
    return false unless Tournament.finished? && bonus_when_final_first_goal.present?

    correct = AppSetting.bonus_answer_when_will_the_first_goal
    correct.present? && bonus_when_final_first_goal == correct
  end

  def how_many_goals_correct?
    return false unless Tournament.finished? && bonus_how_many_goals.present?

    correct = AppSetting.bonus_answer_how_many_goals
    correct.present? && bonus_how_many_goals == correct
  end
end
