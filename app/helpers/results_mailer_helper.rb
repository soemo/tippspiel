# frozen_string_literal: true

module ResultsMailerHelper
  def team_label(team)
    return '?' unless team

    name = team.try(:name)
    tla  = team.try(:football_data_tla)
    tla.present? ? "#{name} (#{tla})" : name.to_s
  end

  def format_time(time)
    return '?' unless time

    time.in_time_zone('UTC').strftime('%Y-%m-%d %H:%M UTC')
  end
end
