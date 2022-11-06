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
    #todo test soeren
    current_user.present? ? current_user.bonus_second_team : nil
  end

  def bonus_second_team_id
    #todo test soeren
    bonus_second_team.present? ? bonus_second_team.id : ''
  end

  def second_team_with_flag
    #todo test soeren
    team = bonus_second_team
    if team.present?
      TeamPresenter.new(team).team_name_with_flag
    else
      I18n.t('no_second_tip')
    end
  end

  def options_for_team_tip_select
    TeamQueries.all_ordered_by_name.map{|t| [t.name, t.id]}
  end

  def round_of_16_name
    I18n.t('round.roundof16')
  end

  def round_of_16_started?
    Tournament.round_of_16_started?
  end

end