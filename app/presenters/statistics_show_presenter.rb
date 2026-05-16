class StatisticsShowPresenter

  attr_reader :current_user
  attr_reader :user_id

  def initialize(current_user, user_id, finished_games)
    @current_user = current_user
    @user_id = user_id
    @finished_games = finished_games
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

  def finished_tips
    TipQueries.all_by_user_id_and_game_ids_ordered_games_start_at(user_to_show.id, @finished_games.map(&:id))
  end

  def user_rankings
    @ranking ||= finished_tips.pluck(:ranking_place).compact.drop(1)
  end

  def header_text
    if shows_current_user_rankings?
      I18n.t(:your_statistic)
    else
      I18n.t(:statistic_for, name: user_to_show.name)
    end
  end

  def line_chart_header_text
    I18n.t(:ranking_per_game)
  end

  def ranking_summary_header_text
    I18n.t(:ranking_summary_header)
  end

  def tips_header_text
    I18n.t(:tips)
  end

  def line_chart_x_labels
    @finished_games.map{ |game| GamePresenter.new(game) }.map{|gp| "#{gp.formatted_start_at_short}: #{gp.team_names_without_flags}"}
  end

  def line_chart_max_ticks
    data = user_rankings.compact
    if data.present?
      [data.max, 5].max
    else
      5 # randomly chosen
    end
  end

  def line_chart_step_size
    result = 5
    data = user_rankings.compact
    if data.present?
      diff = data.max - data.min
      result = 1 if diff < 20
      result = 10 if diff > 50
    end

    result
  end

  def line_chart_data
    {
      labels: line_chart_x_labels,
      datasets: [
        {
          label: I18n.t(:standings),
          fill: 'start',
          tension: 0.3,
          borderColor: "rgba(99,179,237,1)",
          backgroundColor: "rgba(99,179,237,0.15)",
          pointRadius: 4,
          pointBackgroundColor: "rgba(99,179,237,1)",
          pointBorderColor: "#fff",
          pointBorderWidth: 2,
          pointHoverRadius: 6,
          pointHoverBackgroundColor: "#fff",
          pointHoverBorderColor: "rgba(99,179,237,1)",
          pointHoverBorderWidth: 3,
          data: user_rankings
        }
      ]
    }
  end

  def line_chart_options
    {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false
        },
        tooltip: {
          displayColors: false
        }
      },
      scales: {
        x: {
          display: true,
          ticks: {
            display: false
          },
          grid: {
            display: false
          }
        },
        y: {
          reverse: true,
          min: 1,
          max: line_chart_max_ticks,
          ticks: {
            stepSize: line_chart_step_size,
            color: "rgba(160,174,192,1)",
            font: {
              size: 13
            }
          },
          grid: {
            color: "rgba(226,232,240,0.6)"
          }
        }
      }
    }
  end

  def has_data_to_show?
    user_rankings.present? && user_rankings.reject(&:blank?).present?
  end

  def ranking_current
    user_rankings.last
  end

  def ranking_best
    user_rankings.min
  end

  def ranking_worst
    user_rankings.max
  end

  def ranking_current_date
    game_date_for_ranking_index(user_rankings.length - 1)
  end

  def ranking_best_date
    game_date_for_ranking_index(user_rankings.index(ranking_best))
  end

  def ranking_worst_date
    game_date_for_ranking_index(user_rankings.index(ranking_worst))
  end

  private

  def game_date_for_ranking_index(index)
    return nil unless index
    # user_rankings drops the first game, so offset index by 1
    game = @finished_games[index + 1]
    return nil unless game
    I18n.l(game.start_at, format: :short)
  end
end