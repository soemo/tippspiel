class TipPresenter < DelegateClass(Tip)

  attr_reader :tip

  def initialize(tip)
    super(tip)
    @tip = tip
  end

  def pointbadge_large(tip_points, css_classes='')
    pointbadge(tip_points, "large-point-badge #{css_classes}")
  end

  def pointbadge(tip_points, css_classes='')
    if tip_points.present?
      css_classes = "#{css_classes} #{POINTS_TO_CSS_CLASS[tip_points.to_s]}"
      "<span class='#{css_classes} badge' title='#{tip_points} #{User.human_attribute_name('points')}'>#{tip_points}</span>"
    else
     ''
    end
  end
end