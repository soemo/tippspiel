module GameQueries
  class << self

    def started_games
      Game.where('start_at < ?', Time.now)
    end

  end
end