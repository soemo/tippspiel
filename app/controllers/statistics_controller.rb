class StatisticsController < ApplicationController

  def show
    finished_games = GameQueries.all_finished_ordered_by_start_at
    @presenter = StatisticsShowPresenter.new(current_user, params[:id], finished_games)
  end
end
