module NoticeQueries
  class << self

    def order_by_created_at_asc
      Notice.includes(:user).order("created_at desc")
    end

  end
end