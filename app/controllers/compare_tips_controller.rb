class CompareTipsController < ApplicationController

  def show
    result = Tipps::Compare.call(:game_id => params[:game_id])
    @presenter = TippsComparePresenter.new(result.possible_games,
                                           result.game_to_compare,
                                           result.tipps)
  end
end
