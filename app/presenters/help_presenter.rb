class HelpPresenter

  def initialize

  end

  def round_infos
    result = []
      ROUNDS.each do |round|
        start_date_time, end_date_time = Tournament.round_start_end_date_time(round)
        start_date = start_date_time.present? ? I18n.l(start_date_time, format: :only_date) : '-'
        end_date   = end_date_time.present? ? I18n.l(end_date_time, format: :only_date) : '-'
        result << "#{start_date} - #{end_date}: #{I18n.t(round, scope: 'round')}"
      end

    result
  end
end