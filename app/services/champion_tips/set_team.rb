module ChampionTips
  class SetTeam < BaseService

    attribute :championtip_team_id, Integer
    attribute :current_user, User

    def call
      if Tournament.not_yet_started? && championtip_team_id.present?
        current_user.update_column(:championtip_team_id, championtip_team_id)
        true
      else
        false
      end
    end
  end
end