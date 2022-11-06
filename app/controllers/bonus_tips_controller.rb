class BonusTipsController < ApplicationController

  def update
    # todo soeren set all bonus values
    result = BonusTips::SaveAnswers.call(
      bonus_champion_team_id: params[:bonus_champion_team_id],
      bonus_second_team_id: params[:bonus_second_team_id],
      current_user: current_user
    )

    if result
      flash[:notice] = t(:succesfully_saved_bonustip)
    end

    respond_to do |format|
      format.html { redirect_to edit_bonus_path }
    end
  end

end
