module UserQueries
  class << self

    def all_ordered_by_points_and_all_countxpoints
      User.active.order('users.points DESC, users.count8points DESC, users.count5points DESC, users.count4points DESC, users.count3points DESC')
    end

    def needs_random_tips_for_user_id?(user_id)
      User.exists?(id: user_id, create_initial_random_tips: true)
    end
  end
end