class RankingPerGamesShowPresenter

  attr_reader :user_rankings

  def initialize(user_rankings, games)
    @user_rankings = user_rankings
    @games = games
  end

  def chart_x_labels
     @games.map{ |game| GamePresenter.new(game) }.map{|gp| "#{gp.formatted_start_at_short}: #{gp.team_names_without_flags}"}
  end

  # use http://www.chartjs.org/docs/#line-chart-introduction  Version: 2.0.2
  def chart_data
    {
        labels: chart_x_labels,
        datasets: [
            {
                label: I18n.t(:standings),
                fill: false,
                lineTension: 0.2,
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