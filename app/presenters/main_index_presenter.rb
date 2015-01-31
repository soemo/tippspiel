class MainIndexPresenter

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def today_games
    GetTodayGames.call
  end

  def get_user_top3_and_own_position
    GetUserTop3AndOwnPosition.call(:user_id => current_user.id)
  end

end