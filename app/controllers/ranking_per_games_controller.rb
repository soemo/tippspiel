class RankingPerGamesController < ApplicationController

  def show
    games = GameQueries.all_finished_ordered_by_start_at
    @presenter = RankingPerGamesShowPresenter.new(current_user, params[:id], games)
  end
end
