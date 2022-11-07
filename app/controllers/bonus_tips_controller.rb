class BonusTipsController < ApplicationController

  def update
    result = BonusTips::SaveAnswers.call(
      bonus_champion_team_id: params[:bonus_champion_team_id],
      bonus_second_team_id: params[:bonus_second_team_id],
      bonus_when_final_first_goal: params[:bonus_when_final_first_goal],
      bonus_how_many_goals: params[:bonus_how_many_goals],
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
