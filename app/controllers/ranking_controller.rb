class RankingController < ApplicationController

  def index
    @user_ranking_hash = User.prepare_user_ranking
  end

end
