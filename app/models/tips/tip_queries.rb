module TipQueries
  class << self

    def get_ordered_tips_for_game_id(game_id)
      if game_id.present?
        Tip.where(game_id: game_id).
            includes('user').
            where('users.deleted_at' => nil).
            order('tips.tip_points desc').
            order('users.firstname asc')
      else
        []
      end
    end

  end
end