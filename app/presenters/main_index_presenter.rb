class MainIndexPresenter

  attr_reader :tips
  attr_reader :current_user

  def initialize(tips, current_user)
    @tips = tips
    @current_user = current_user
  end

  def bonus_question_link_text
     if current_user.all_bonus_questions_filled_out?
      I18n.t('go_to_bonus_question_page_check')
    else
      I18n.t('go_to_bonus_question_page_fill_out')
    end
  end

  def tip_presenters
    tips.map { |tip| TipPresenter.new(tip) }
  end

  def tournament_finished?
    Tournament.finished?
  end

  def tournament_started?
    Tournament.started?
  end

  def user_name
    current_user.name
  end

end