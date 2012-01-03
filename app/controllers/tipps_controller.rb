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
        if new_tipps["#{tipp.id}"].present?
          tore1 =

          tipp.update_attributes({:team1_tore => new_tipps["#{tipp.id}"]["team1_tore"], :team2_tore => new_tipps["#{tipp.id}"]["team2_tore"]})
        end
      end
    end
    # TODO soeren 03.01.12 wenn ein Tipp nicht valid ist dann Fehlermeldung
    # t("error_saved_tipps")"
    msg = {:notice => t("succesfully_saved_tipps")}

    redirect_to({:action => "index"}, msg)
  end

end
