class GamesPresenter

  attr_reader :current_user

  def initialize(current_user, for_admin)
    @current_user = current_user
    @for_admin = for_admin
  end

  def games
    ::GameQueries.all_ordered_by_start_at
  end

  def game_presenters
    games.map { |game| GamePresenter.new(game) }
  end

  def show_edit_link?
    @current_user.present? && @current_user.admin? && @for_admin
  end
end