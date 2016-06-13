class MainIndexPresenter

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def tournament_finished?
    Tournament.finished?
  end

  def get_user_top3_and_own_position
    Users::Top3AndOwnPosition.call(:user_id => current_user.id)
  end

  def games_presenter
    GamesPresenter.new(current_user, false)
  end
  
  def user_points
    current_user.points
  end

end