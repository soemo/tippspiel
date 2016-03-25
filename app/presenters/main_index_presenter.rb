class MainIndexPresenter

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def tournament_started?
    Tournament.started?
  end

  def tournament_finished?
    Tournament.finished?
  end

  def get_user_top3_and_own_position
    Users::Top3AndOwnPosition.call(:user_id => current_user.id)
  end

end