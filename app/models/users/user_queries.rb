module UserQueries
  class << self

    def all_ordered_by_points_and_all_countxpoints
      User.active.order('users.points DESC, users.count8points DESC, users.count5points DESC, users.count4points DESC, users.count3points DESC')
    end

    def all_championtips_teams_by_user_ids

    end
  end
end