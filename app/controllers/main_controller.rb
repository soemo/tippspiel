# -*- encoding : utf-8 -*-
class MainController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
    @today_games = GetTodayGames.call
    if user_signed_in?
      @user_top3_ranking_hash, @own_position = GetUserTop3AndOwnPosition.call(:user_id => current_user.id)
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
