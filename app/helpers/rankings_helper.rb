module RankingsHelper

  def statistic_content(user)
    result = ''

    if user.present?
      POINTS_TO_CSS_CLASS.each do |key, css_class|
        count = user.send("count#{key}points")
        count = count.present? ? count : 0
        result << pointbadge_with_content(count, css_class, "x #{key} #{User.human_attribute_name('points')}")
      end
      # todo soeren refactoring - sum of all bonus points
      champion_tippoints = user.bonus_points
      champion_tippoint_title = "#{User.human_attribute_name('bonuspoints')}: #{champion_tippoints}"
      css_class = POINTS_TO_CSS_CLASS["#{champion_tippoints}"] # todo ACHTUNG kann mehr als 8 sein
      result << '&nbsp;&nbsp'
      result << pointbadge_with_content('B', css_class, champion_tippoint_title)
    end

    result
  end

  def pointbadge_with_content(content, css_class, title)
    "<span class='#{css_class} badge' title='#{title}'>#{content}</span>"
  end
end
