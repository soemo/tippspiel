module NoticeQueries
  class << self

    def last_updated_at
      Notice.maximum('updated_at')
    end

    def order_by_created_at_asc
      Notice.includes(:user).order("created_at desc")
    end

  end
end