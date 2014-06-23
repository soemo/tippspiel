# -*- encoding : utf-8 -*-
class RankingController < ApplicationController

  def index
    @user_count        = User.active.count
    @user_ranking_hash = User.prepare_user_ranking
  end

  def hall_of_fame
    # wird intern mit fragment-cache gecached
  end


end
