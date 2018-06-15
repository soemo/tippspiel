class RankingPerGamesShowPresenter

  attr_reader :current_user
  attr_reader :user_id

  def initialize(current_user, user_id, games)
    @current_user = current_user
    @user_id = user_id
    @games = games
  end

  def user_to_show
    @user_to_show ||= begin
      if shows_current_user_rankings?
        current_user
      else
        User.find(user_id)
      end
    end
  end

  def shows_current_user_rankings?
    user_id.present? && user_id.to_i == current_user.id
  end

  def user_rankings
    @ranking ||= begin
      TipQueries.all_by_user_id_ordered_games_start_at(user_to_show.id).pluck(:ranking_place).compact
    end
  end

  def header_text
    if shows_current_user_rankings?
      I18n.t(:your_ranking_per_game)
    else
      I18n.t(:ranking_per_game_for, name: user_to_show.name)
    end
  end

  def chart_x_labels
    @games.map{ |game| GamePresenter.new(game) }.map{|gp| "#{gp.formatted_start_at_short}: #{gp.team_names_without_flags}"}
  end

  def chart_max_ticks
    data = user_rankings.compact
    if data.present?
      [data.max, 5].max
    else
      5 # randomly chosen
    end
  end

  def chart_step_size
    result = 1
    data = user_rankings.compact
    if data.present?
      diff = data.max - data.min
      result = 5 if diff > 20
      result =10 if diff > 80
    end

    result
  end

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
                data: user_rankings
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
              reverse: true,
              min: 1,
              max: chart_max_ticks,
              stepSize: chart_step_size 
            }
          }
        ]
      },
    }
  end

  def has_chart_data_to_show?
    user_rankings.present? && user_rankings.reject(&:blank?).present?
  end
end