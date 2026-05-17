# frozen_string_literal: true

module Admin
  class BonusSettingsController < Admin::BaseController
    def new
      @bonus_how_many_goals    = AppSetting.bonus_answer_how_many_goals
      @bonus_when_first_goal   = AppSetting.bonus_answer_when_will_the_first_goal
      @when_first_goal_options = BONUS_OPTIONS_WHEN_WILL_THE_FIRST_GOAL
    end

    def create
      AppSetting.set_bonus_answer_how_many_goals(params[:bonus_how_many_goals])
      AppSetting.set_bonus_answer_when_will_the_first_goal(params[:bonus_when_final_first_goal])

      flash[:notice] = I18n.t('bonus_settings_saved')
      redirect_to new_admin_bonus_settings_path
    end
  end
end
