module GameQueries
  class << self

    def first_game_in_tournament
      Game.order('start_at asc').first
    end

    def last_updated_at
      Game.maximum('updated_at')
    end

    def started_games
      Game.where('start_at < ?', Time.now)
    end

  end
end