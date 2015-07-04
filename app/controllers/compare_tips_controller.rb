class CompareTipsController < ApplicationController

  def show
    result = Tips::Compare.call(:game_id => params[:game_id])
    @presenter = TipsComparePresenter.new(result.possible_games,
                                           result.game_to_compare,
                                           result.tips)
  end
end
