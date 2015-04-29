# -*- encoding : utf-8 -*-
module Tipps
  class Save < BaseService

    attribute :current_user, User
    attribute :tipps_params

    def call
      save
    end

    private

    def save
      if tipps_params.present? && current_user.present?
        user_tipps = Tipps::FromUser.call(:user_id => current_user.id)
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
end