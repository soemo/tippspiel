module RankingsHelper

  def statistic_content(user)
    result = ''

    if user.present?
      POINTS_TO_CSS_CLASS.each do |key, css_class|
        count = user.send("count#{key}points")
        count = count.present? ? count : 0
        result << pointbadge_with_content(count, css_class, "x #{key} #{User.human_attribute_name('points')}")
      end

      champion_tippoints = user.championtippoints
      champion_tippoint_title = "#{User.human_attribute_name('points')} #{User.human_attribute_name('siegertipp')}: #{champion_tippoints}"
      css_class = POINTS_TO_CSS_CLASS["#{champion_tippoints}"]
      result << '&nbsp;&nbsp'
      result << pointbadge_with_content(icon('fas', 'trophy'), css_class, champion_tippoint_title)
    end

    result
  end

  def pointbadge_with_content(content, css_class, title)
    "<span class='#{css_class} badge' title='#{title}'>#{content}</span>"
  end
end
