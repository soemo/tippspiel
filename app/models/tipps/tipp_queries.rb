module TippQueries
  class << self

    def get_ordered_tipps_for_game_id(game_id)
      if game_id.present?
        Tipp.where(game_id: game_id).
            includes('user').
            where('users.deleted_at' => nil).
            order('tipps.tipp_punkte desc').
            order('users.firstname asc')
      else
        []
      end
    end

  end
end