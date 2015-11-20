# -*- encoding : utf-8 -*-
class TipsController < ApplicationController

  before_filter :get_for_phone

  def get_for_phone
    # Liste der Tips wird auf dem Phone komprimierter dargestellt #72 besser machen # TODO soeren 30.04.15
    @for_phone = (params.has_key?(:for_phone) && params[:for_phone] == 'true') ? true : false
  end

  def index
    @today_game_ids   = Games::PlayToday.call.pluck(:id)
    user_tips        = Tips::FromUser.call(:user_id => current_user.id)
    @tips_round_hash = Tips::SeparatedByRounds.call(tips: user_tips)

    respond_to do |format|
      if @for_phone
        format.html { render 'index_for_phone' }
      else
        format.html { render 'index' }
      end
    end
  end
          # TODO soeren 30.04.15  maybe own Controller
  def save_tips
    Tips::Save.call(tips_params: params[:tips], current_user: current_user)
    redirect_to({:action => 'index', :for_phone => @for_phone}, {:notice => t('succesfully_saved_tips')})
  end

  # TODO soeren 30.04.15 Use Service and Controller with Specs!!!
  def save_champion_tip
    if Tournament.before?
      if params[:champion_team_id].present?
        current_user.championtip_team_id = params[:champion_team_id]
        if current_user.save
          flash[:notice] = t(:succesfully_saved_championtip)
        end # no else
      end
    end

    respond_to do |format|
      format.html { redirect_to :action => 'index', :for_phone => @for_phone }
    end
  end

end
