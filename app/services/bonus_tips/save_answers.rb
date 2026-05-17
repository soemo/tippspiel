# frozen_string_literal: true

module BonusTips
  class SaveAnswers < BaseService
    attribute :bonus_champion_team_id
    attribute :bonus_second_team_id
    attribute :bonus_when_final_first_goal
    attribute :bonus_how_many_goals
    attribute :current_user

    def call
      if Tournament.round_of_16_not_yet_started?
        current_user.update_columns( # rubocop:disable Rails/SkipsModelValidations -- intentional: bypass callbacks for direct column write
          bonus_champion_team_id: bonus_champion_team_id,
          bonus_second_team_id: bonus_second_team_id,
          bonus_when_final_first_goal: bonus_when_final_first_goal,
          bonus_how_many_goals: bonus_how_many_goals
        )
      else
        false
      end
    end
  end
end
