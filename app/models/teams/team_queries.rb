module TeamQueries
  class << self

    def by_name(name)
      Team.where(name: name)
    end

    def last_updated_at
      Team.maximum('updated_at')
    end

  end
end