class MainController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
    @games_round_hash = Game.splited_by_rounds
    @today_games      = Game.today_games
    if current_user.present?
      # TODO soeren 20.04.12 Spiele von heute
      # TODO soeren 20.04.12 top 3 Ranking
      # TODO soeren 20.04.12 später den Sieger ermittlen
    end

  end

end