class RankingPerGamesController < ApplicationController

  def show
    games = GameQueries.all_finished_ordered_by_start_at
    user_rankings = TipQueries.all_by_user_id_ordered_games_start_at(current_user.id).pluck(:ranking_place)

    @presenter = RankingPerGamesShowPresenter.new(user_rankings, games)
  end
end
