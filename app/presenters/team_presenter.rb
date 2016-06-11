class TeamPresenter < DelegateClass(Team)
  include ActionView::Helpers::OutputSafetyHelper

  attr_reader :team

  def initialize(team)
    super(team)
    @team = team
  end

  # flag_size: 16 or 32
  # flag_position: left or right
  def team_name_with_flag(flag_size: 32, flag_position: 'left')
    flag = teamflag(flag_size)
    case flag_position
      when 'left'
        raw "#{flag} #{@team.name}"
      when 'right'
        raw "#{@team.name} #{flag}"
      else
        raise "Wrong flag_position #{flag_position}"
    end
  end

  def teamflag(flag_size)
    flag_span_css_class = "f#{flag_size}"
    "<span class='#{flag_span_css_class}'><i class='flag #{@team.country_code}'></i></span>"
  end
end