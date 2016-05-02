class GamesPresenter

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def games
    ::GameQueries.all_ordered_by_start_at
  end

  def game_presenters
    games.map { |game| GamePresenter.new(game) }
  end

  def show_edit_link?
    @current_user.present? && @current_user.admin?
  end
end