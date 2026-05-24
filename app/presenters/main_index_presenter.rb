# frozen_string_literal: true

class MainIndexPresenter
  attr_reader :tips, :current_user

  def initialize(tips, current_user)
    @tips = tips
    @current_user = current_user
  end

  def bonus_question_link_text
    if current_user.present? &&
       (current_user.all_bonus_questions_filled_out? || tournament_finished?)
      I18n.t('go_to_bonus_question_page_check')
    else
      I18n.t('go_to_bonus_question_page_fill_out')
    end
  end

  # Returns an array of [TipPresenter, GamePresenter] pairs so the view does
  # not need to re-instantiate GamePresenter for every row.
  def tip_and_game_presenter_pairs
    tips.map { |tip| [TipPresenter.new(tip), GamePresenter.new(tip.game)] }
  end

  def tournament_finished?
    @tournament_finished ||= Tournament.finished?
  end

  def tournament_started?
    @tournament_started ||= Tournament.started?
  end

  def user_name
    current_user.name
  end
end
