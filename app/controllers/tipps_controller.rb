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

end
