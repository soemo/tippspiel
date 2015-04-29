module TeamQueries
  class << self

    def last_updated_at
      Team.maximum('updated_at')
    end

  end
end