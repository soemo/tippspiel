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

    def ordered_started_at_for(round)
      Game.where(:round => round).order(start_at: :asc).pluck('start_at')
    end
          # FIXME soeren 19.09.15 spec

    def all_finished_ordered_by_start_at
      Game.finished.order(start_at: :asc)
    end

  end
end