class GameListCell < Cell::Rails
  helper ApplicationHelper

  # Caching, es wird aktualisiert, wenn ein Spiel oder Team aktualisiert wurde
  cache :show do |options|
    options[:last_updated_at].to_i
  end

  def show(args)
    @games_round_hash = Game.splited_by_rounds

    render
  end

end
