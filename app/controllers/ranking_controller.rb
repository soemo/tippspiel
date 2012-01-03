class RankingController < ApplicationController

  def index
    @ranking_user = User.ranking_order
  end

end
