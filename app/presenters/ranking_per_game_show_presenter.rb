class RankingPerGameShowPresenter

  attr_reader :user_rankings

  def initialize(user_rankings, chart_x_labels)
    @user_rankings = user_rankings
    @chart_x_labels = chart_x_labels
  end

  # use http://www.chartjs.org/  Version: 1.0.2
  def chart_data
    {
        labels: @chart_x_labels,
        datasets: [

            {
                label: I18n.t(:your_ranking_per_game),
                fillColor: "rgba(151,187,205,0.2)",
                strokeColor: "rgba(151,187,205,1)",
                pointColor: "rgba(151,187,205,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(151,187,205,1)",
                data: @user_rankings
            }
        ]
    }
  end

  def chart_options
    {
        responsive: true,
        bezierCurve: true,
        # Hack to get 1 at top, try Charts Version 2.0
        scaleOverride: true,
        scaleSteps: @user_rankings.max - 1,
        scaleStepWidth: -1,
        scaleStartValue: @user_rankings.max,

        showTooltips: false
    }
  end

  def has_chart_data_to_show?
    @user_rankings.present? && @user_rankings.reject(&:blank?).present?
  end
end