class MainIndexPresenter

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
    champ_team = championtip_team
    TeamPresenter.new(champ_team).team_name_with_flag if champ_team.present?
  end

  def options_for_champion_tip_select
    TeamQueries.all_ordered_by_name.map{|t| [t.name, t.id]}
  end

  def tip_presenters
    tips.map { |tip| TipPresenter.new(tip) }
  end

  def tournament_finished?
    Tournament.finished?
  end

  def get_user_top3_and_own_position
    Users::Top3AndOwnPosition.call(:user_id => current_user.id)
  end

  def user_points
    current_user.points
  end

  def user_name
    current_user.name
  end

end