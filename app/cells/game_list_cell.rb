class GameListCell < Cell::Rails
  helper ApplicationHelper

  # Caching, es wird aktualisiert, wenn ein Spiel oder Team aktualisiert wurde
  cache :show do |options|
    options[:last_updated_at].to_i
  end

  def show(args)
    @games = GameQueries.all_ordered_by_start_at

    render
  end

end
