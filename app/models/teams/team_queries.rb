module TeamQueries
  class << self

    def all_ordered_by_name
      Team.order('name')
    end
  end
end