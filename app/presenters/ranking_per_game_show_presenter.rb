class RankingPerGameShowPresenter

  attr_reader :user_rankings

  def initialize(user_rankings, chart_x_labels)
    @user_rankings = user_rankings
    @chart_x_labels = chart_x_labels
  end

  # use http://www.chartjs.org/docs/#line-chart-introduction  Version: 2.0.2
  def chart_data
    {
        labels: @chart_x_labels,
        datasets: [
            {
                label: I18n.t(:your_ranking_per_game),
                fill: false,
                borderColor: "rgba(75,192,192,1)",
                pointBorderColor: "rgba(75,192,192,1)",
                pointBackgroundColor: "#fff",
                pointHoverBackgroundColor: "rgba(75,192,192,1)",
                pointHoverBorderColor: "rgba(220,220,220,1)",
                data: @user_rankings
            }
        ]
    }
  end

  def chart_options
    {
        legend: {
            position: 'bottom'
        },
        responsive: true,
        scales: {
            xAxes: [
                {
                    display: false
                }
            ],
            yAxes: [
                {
                    ticks: {
                        reverse: true
                    }
                }
            ]
        },
    }
  end

  def has_chart_data_to_show?
    @user_rankings.present? && @user_rankings.reject(&:blank?).present?
  end
end