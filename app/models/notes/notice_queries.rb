# frozen_string_literal: true

module NoticeQueries
  class << self
    def order_by_created_at_desc
      Notice.includes(:user).order(created_at: :desc)
    end
  end
end
