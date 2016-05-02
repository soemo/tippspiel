module TeamQueries
  class << self
        # FIXME soeren 5/1/16 spec
    def all_ordered_by_name
      Team.order('name')
    end
  end
end