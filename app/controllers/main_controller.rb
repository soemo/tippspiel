# -*- encoding : utf-8 -*-
class MainController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
    @today_games = Game.today_games.all
    if user_signed_in?
      @user_top3_ranking_hash, @own_position = User.top3_positions_and_own_position(current_user.id)
    end
  end

  def error
    # extra Text fuer die Errorseite, aber nur wenn ein 500 Fehler fliegt
    if I18n.t(:error_internal) == flash[:error]
      @error_msg = {
          :text => t(:error_500_text)
      }
    end
  end

end
