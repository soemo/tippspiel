# -*- encoding : utf-8 -*-
class TippsController < ApplicationController

  before_filter :get_for_phone

  def get_for_phone
    # Liste der Tipps wird auf dem Phone komprimierter dargestellt #72 besser machen
    @for_phone = (params.has_key?(:for_phone) && params[:for_phone] == 'true') ? true : false
  end

  def index
    @today_game_ids = GetTodayGames.call.pluck(:id)
    @user_tipps     = GetUserTipps.call(:user_id => current_user.id)

    respond_to do |format|
      if @for_phone
        format.html { render 'index_for_phone' }
      else
        format.html { render 'index' }
      end
    end
  end

  def compare
    result = CompareTipps.call(:game_id => params[:id])
    @presenter = TippsComparePresenter.new(result.possible_games,
                                           result.game_to_compare,
                                           result.tipps)
  end
                # FIXME soeren 10.09.2014 Service
  def save_tipps
    new_tipps = params[:tipps]
    if new_tipps.present?
      current_user_id = current_user.id
      user_tipps = GetUserTipps.call(:user_id => current_user_id)
      user_tipps.each do |tipp|
        if (new_tipps["#{tipp.id}"].present? && can?(:update, tipp)) && tipp.edit_allowed?
          tipp.team1_goals = new_tipps["#{tipp.id}"]['team1_goals']
          tipp.team2_goals = new_tipps["#{tipp.id}"]['team2_goals']
          tipp.remove_leading_zero
          tipp.save
        end
      end
    end
    redirect_to({:action => 'index', :for_phone => @for_phone}, {:notice => t('succesfully_saved_tipps')})
  end

  # FIXME soeren 12.06.2014 absichern, das nach Turnierstart nicht mehr gespeichert werden kann
  def save_champion_tipp
    respond_to do |format|
      if params[:champion_team_id].present?
        current_user.championtipp_team_id = params[:champion_team_id]
        if current_user.save
          flash[:notice] = t(:succesfully_saved_championtipp)
          format.html { redirect_to :action => 'index', :for_phone => @for_phone }
        end # no else
      else
        format.html { redirect_to :action => 'index', :for_phone => @for_phone }
      end
    end
  end

end
