class TipsIndexPresenter

  attr_reader :tips
  attr_reader :current_user

  def initialize(tips, current_user)
    @tips = tips
    @current_user = current_user
  end

  def championtip_team
    current_user.present? ? current_user.championtip_team : nil
  end
  
  def championtip_team_with_flag
    # TODO soeren 6/11/16 Spec
    TeamPresenter.new(championtip_team).team_name_with_flag if championtip_team.present?
  end

  def options_for_champion_tip_select
    TeamQueries.all_ordered_by_name.map{|t| [t.name, t.id]}
  end

  def tip_presenters
    tips.map { |tip| TipPresenter.new(tip) }
  end

end