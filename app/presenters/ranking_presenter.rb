class RankingPresenter

  # TODO soeren 3/31/16 specs

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def finshed_games_count
    GameQueries.finished.count
  end

  def all_games_count
    Game.count
  end

  def user_count
    User.active.count
  end

  def user_ranking_hash
    user_ranking = Users::PrepareRanking.call(users_for_ranking: ::UserQueries.all_ordered_by_points_and_all_countxpoints)
    user_ranking.sort
  end

end