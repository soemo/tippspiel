# -*- encoding : utf-8 -*-
class RankingController < ApplicationController

  def index
    @user_count        = User.active.count
    @user_ranking_hash = Users::PrepareRanking.call(users_for_ranking: UserQueries.all_for_ranking_ordered_by_points)
  end

end
