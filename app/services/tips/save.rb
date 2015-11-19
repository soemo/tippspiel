# -*- encoding : utf-8 -*-
module Tips
  class Save < BaseService

    attribute :current_user, User
    attribute :tips_params

    def call
      if tips_params.present? && current_user.present?
        user_tips = Tips::FromUser.call(user_id: current_user.id)
        user_tips.each do |tip|
          tip_param_key = tip.id.to_s
          if tips_params[tip_param_key].present? && tip.edit_allowed?
            tip.team1_goals = tips_params[tip_param_key]['team1_goals']
            tip.team2_goals = tips_params[tip_param_key]['team2_goals']
            tip.remove_leading_zero
            tip.save
          end
        end
      end
    end

  end
end