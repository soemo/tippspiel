class RankingsController < ApplicationController

  def index
    @presenter = RankingPresenter.new
  end
end
