# -*- encoding : utf-8 -*-
module Tips
  class Save < BaseService

    attribute :current_user, User
    attribute :tips_params

    def call
      save
    end

    private

    def save
      if tips_params.present? && current_user.present?
        user_tips = Tips::FromUser.call(:user_id => current_user.id)
        user_tips.each do |tip|
          if tips_params["#{tip.id}"].present? && tip.edit_allowed?
            tip.team1_goals = tips_params["#{tip.id}"]['team1_goals']
            tip.team2_goals = tips_params["#{tip.id}"]['team2_goals']
            tip.remove_leading_zero
            tip.save
          end
        end
      end
    end

  end
end