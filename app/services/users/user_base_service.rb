module Users
  class UserBaseService < BaseService

    private

    def ranking_comparison_value(points, count8points, count5points, count4points, count3points)
      str_points       = points.to_s.rjust(2,'0')
      str_count8points = count8points.to_s.rjust(2,'0')
      str_count5points = count5points.to_s.rjust(2,'0')
      str_count4points = count4points.to_s.rjust(2,'0')
      str_count3points = count3points.to_s.rjust(2,'0')
      "#{str_points}#{str_count8points}#{str_count5points}#{str_count4points}#{str_count3points}".to_i
    end


  end
end