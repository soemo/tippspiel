class TipPresenter < DelegateClass(Tip)

  attr_reader :tip

  def initialize(tip)
    super(tip)
    @tip = tip
  end

  # FIXME soeren 4/29/16 spec
  def pointbadge_large(tip_points, css_classes='')
    pointbadge(tip_points, "large-point-badge #{css_classes}")
  end

  # FIXME soeren 4/29/16 spec
  def pointbadge(tip_points, css_classes='')
    css_classes = "#{css_classes} #{POINTS_TO_CSS_CLASS[tip_points.to_s]}"
    "<span class='#{css_classes} badge' title='#{tip_points} #{User.human_attribute_name('points')}'>#{tip_points}</span>"
  end
end