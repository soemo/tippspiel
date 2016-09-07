class ChampionTipsController < ApplicationController

  def update

    result = ChampionTips::SetTeam.call(championtip_team_id: params[:championtip_team_id], current_user: current_user)

    if result
      flash[:notice] = t(:succesfully_saved_championtip)
    end

    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

end
