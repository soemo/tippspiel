module UserQueries
  class << self
                          # FIXME soeren 19.09.15 spec
    def all_for_ranking_ordered_by_points
      User.active.ranking_order
    end
  end
end