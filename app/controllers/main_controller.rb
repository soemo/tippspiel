class MainController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
    @games_round_hash = Game.splited_by_rounds
  end

end