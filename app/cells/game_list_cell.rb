class GameListCell < Cell::Rails
  helper ApplicationHelper
  # Caching, es wird aktualisiert, wenn ein Spiel oder Team aktualisiert wurde
  cache :show do |options|
    options[:last_updated_at].to_i
  end

  def show(args)
    Rails.logger.info("test sm in GameListCell Start") # FIXME soeren 29.04.14 wieder raus
    @games_round_hash = Game.splited_by_rounds
    Rails.logger.info("test sm in GameListCell End") # FIXME soeren 29.04.14 wieder raus
    render
  end

end
