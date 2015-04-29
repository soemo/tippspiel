# -*- encoding : utf-8 -*-
class RankingController < ApplicationController

  def index
    @user_count        = User.active.count
    @user_ranking_hash = PrepareUserRanking.call
  end

end
