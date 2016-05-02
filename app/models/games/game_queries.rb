module GameQueries
  class << self

    def all_ordered_by_start_at
      Game.preload(:team1, :team2).order(start_at: :asc)
    end

    def all_game_ids
      Game.pluck(:id)
    end

    def final_game
      Game.where(round: FINAL).first
    end

    def finished
      Game.where(finished: true)
    end

    def first_game_in_tournament
      GameQueries.all_ordered_by_start_at.first
    end

    def started_games
      Game.where('start_at <= ?', Time.now)
    end

    def ordered_started_at_for(round)
      Game.where(:round => round).order(start_at: :asc).pluck('start_at')
    end

    def all_finished_ordered_by_start_at
      Game.where(finished: true).order(start_at: :asc)
    end

  end
end