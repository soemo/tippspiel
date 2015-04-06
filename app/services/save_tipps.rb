# -*- encoding : utf-8 -*-
class SaveTipps < BaseService

  attribute :current_user, User
  attribute :tipps_params

  def call
    save_tipps
  end

  private

  def save_tipps
    if tipps_params.present? && current_user.present?
      user_tipps = GetUserTipps.call(:user_id => current_user.id)
      user_tipps.each do |tipp|
        if tipps_params["#{tipp.id}"].present? && tipp.edit_allowed?
          tipp.team1_goals = tipps_params["#{tipp.id}"]['team1_goals']
          tipp.team2_goals = tipps_params["#{tipp.id}"]['team2_goals']
          tipp.remove_leading_zero
          tipp.save
        end
      end
    end
  end

end