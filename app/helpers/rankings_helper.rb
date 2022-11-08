module RankingsHelper

  def statistic_content(user)
    result = ''

    if user.present?
      POINTS_TO_CSS_CLASS.each do |key, css_class|
        count = user.send("count#{key}points")
        count = count.present? ? count : 0
        result << pointbadge_with_content(count, css_class, "x #{key} #{User.human_attribute_name('points')}")
      end
      bonus_tips_points = user.bonus_points
      bonus_tips_points = bonus_tips_points.present? ? bonus_tips_points : 0
      bonus_tips_points_title = "#{User.human_attribute_name('bonuspoints')}: #{bonus_tips_points}"
      css_class = "badge-bonus #{POINTS_TO_CSS_CLASS["#{bonus_tips_points}"]}"
      result << '&nbsp;&nbsp'
      result << pointbadge_with_content(bonus_tips_points, css_class, bonus_tips_points_title)
    end

    result
  end

  def pointbadge_with_content(content, css_class, title)
    "<span class='badge #{css_class}' title='#{title}'>#{content}</span>"
  end
end
