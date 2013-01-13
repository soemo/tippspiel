# -*- encoding : utf-8 -*-
class MainController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
    @games_round_hash = Game.splited_by_rounds
    @today_games      = Game.today_games
    if user_signed_in?
      @user_top3_ranking_hash, @own_position = User.top3_positions_and_own_position(current_user.id)
    end
  end

  def error
    # view error wird gerendert
  end

end
