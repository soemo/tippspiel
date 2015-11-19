module TipQueries
  class << self

    def all_ordered_by_tip_points_and_user_firstname_by_game_id(game_id)
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

    def all_by_game_id(game_id)
      Tip.where(game_id: game_id)
    end

    def all_by_game_ids_and_tip_points(game_ids, tip_points)
      Tip.where({game_id: game_ids, tip_points: tip_points}).select('id, user_id, game_id, tip_points')
    end

    def all_by_user_id_with_preloaded_games(user_id)
      Tip.preload(:game).where(user_id: user_id)
    end

    def all_by_user_id_and_tip_points(user_id, tip_points)
      Tip.where({user_id: user_id, tip_points: tip_points})
    end

    def all_by_user_id_and_game_ids(user_id, game_ids)
      Tip.where({user_id: user_id, game_id: game_ids})
    end

    def sum_tip_points_by_user_id(user_id)
      Tip.where(user_id: user_id).sum(:tip_points)
    end

    def sum_tip_points_group_by_user_id_by_game_ids(game_ids)
      Tip.where(game_id: game_ids).group(:user_id).sum(:tip_points)
    end

  end
end