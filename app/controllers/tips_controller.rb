class TipsController < ApplicationController

          # TODO soeren 30.04.15  maybe own Controller
  def save_tips
    Tips::Save.call(tips_params: params[:tips], current_user: current_user)
    msg =  params[:tips].present? ? t('succesfully_saved_tips') : ''
    redirect_to(root_path, {notice: msg})
  end

  # TODO soeren 30.04.15 Use Service and Controller with Specs!!!
  def save_champion_tip
    if Tournament.not_yet_started?
      if params[:champion_team_id].present?
        current_user.championtip_team_id = params[:champion_team_id]
        if current_user.save
          flash[:notice] = t(:succesfully_saved_championtip)
        end # no else
      end
    end

    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

end
