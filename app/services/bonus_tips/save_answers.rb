module BonusTips
  class SaveAnswers < BaseService

    attribute :bonus_champion_team_id, Integer
    attribute :bonus_second_team_id, Integer
    attribute :current_user, User

    def call

      if Tournament.round_of_16_not_yet_started?
        current_user.update_columns(
          bonus_champion_team_id: bonus_champion_team_id,
          bonus_second_team_id: bonus_second_team_id
        )
      else
        false
      end
    end
  end
end