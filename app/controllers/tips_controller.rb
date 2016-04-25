class TipsController < ApplicationController

  def index
    # TODO soeren 3/25/16 tipps sortiert wie die spiele nach start_at
    @tips = Tips::FromUser.call(user_id: current_user.id)
    # FIXME soeren 3/25/16 needs presenter
    respond_to do |format|
      format.html { render 'index' }
    end
  end
          # TODO soeren 30.04.15  maybe own Controller
  def save_tips
    Tips::Save.call(tips_params: params[:tips], current_user: current_user)
    redirect_to({action: :index}, {notice: t('succesfully_saved_tips')})
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
      format.html { redirect_to action: :index }
    end
  end

end
