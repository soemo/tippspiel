class HelpPresenter

  def initialize

  end
  def bonus_questions
    [
      I18n.t('bonus_questions.which_team_is_champion'),
      I18n.t('bonus_questions.which_team_is_second'),
      I18n.t('bonus_questions.how_many_goals'),
      I18n.t('bonus_questions.when_final_first_goal'),
    ]
  end

  def round_of_16_name
    I18n.t('round.roundof16')
  end

  def round_infos
    result = []
      ROUNDS.each do |round|
        start_date_time, end_date_time = Tournament.round_start_end_date_time(round)
        start_date = start_date_time.present? ? I18n.l(start_date_time, format: :only_date) : '-'
        end_date   = end_date_time.present? ? I18n.l(end_date_time, format: :only_date) : '-'
        if end_date == start_date
          result << "#{end_date}: #{I18n.t(round, scope: 'round')}"
        else
          result << "#{start_date} - #{end_date}: #{I18n.t(round, scope: 'round')}"
        end
      end

    result
  end
end