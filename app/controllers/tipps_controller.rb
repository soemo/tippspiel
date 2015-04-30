# -*- encoding : utf-8 -*-
class TippsController < ApplicationController

  before_filter :get_for_phone

  def get_for_phone
    # Liste der Tipps wird auf dem Phone komprimierter dargestellt #72 besser machen # TODO soeren 30.04.15
    @for_phone = (params.has_key?(:for_phone) && params[:for_phone] == 'true') ? true : false
  end

  def index
    @today_game_ids   = Games::PlayToday.call.pluck(:id)
    user_tipps        = Tipps::FromUser.call(:user_id => current_user.id)
    @tipps_round_hash = Tipps::SeparatedByRounds.call(tipps: user_tipps)

    respond_to do |format|
      if @for_phone
        format.html { render 'index_for_phone' }
      else
        format.html { render 'index' }
      end
    end
  end
          # TODO soeren 30.04.15  maybe own Controller
  def save_tipps
    Tipps::Save.call(tipps_params: params[:tipps], current_user: current_user)
    redirect_to({:action => 'index', :for_phone => @for_phone}, {:notice => t('succesfully_saved_tipps')})
  end

  # TODO soeren 30.04.15 Use Service and maybe own Controller
  def save_champion_tipp
    if Tournament.before?
      if params[:champion_team_id].present?
        current_user.championtipp_team_id = params[:champion_team_id]
        if current_user.save
          flash[:notice] = t(:succesfully_saved_championtipp)
        end # no else
      end
    end

    respond_to do |format|
      format.html { redirect_to :action => 'index', :for_phone => @for_phone }
    end
  end

end
