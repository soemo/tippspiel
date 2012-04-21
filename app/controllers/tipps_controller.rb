class TippsController < ApplicationController

  def index
    @user_tipps = Tipp.user_tipps(current_user.id)
  end

  def save_tipps
    new_tipps = params[:tipps]
    if new_tipps.present?
      current_user_id = current_user.id
      user_tipps = Tipp.user_tipps(current_user_id)
      user_tipps.each do |tipp|
        if (new_tipps["#{tipp.id}"].present? && can?(:update, tipp))
          tipp.team1_goals = new_tipps["#{tipp.id}"]["team1_goals"]
          tipp.team2_goals = new_tipps["#{tipp.id}"]["team2_goals"]
          tipp.remove_leading_zero
          tipp.save
        end
      end
    end
    redirect_to({:action => "index"}, {:notice => t("succesfully_saved_tipps")})
  end

  def save_champion_tipp
    respond_to do |format|
      if params[:champion_team_id].present?
        current_user.championtipp_team_id = params[:champion_team_id]
        if current_user.save
          flash[:notice] = t(:succesfully_saved_championtipp)
          format.html { redirect_to :action => "index" }
        end # no else
      else
        format.html { redirect_to :action => "index" }
      end
    end
  end

end
