class RankingPerGameController < ApplicationController

  def show
    # FIXME soeren 19.07.15 use service and try to cache
    games = GameQueries.all_finished_ordered_by_start_at
    labels = games.map(&:to_s)

    user_rankings =  TipQueries.all_by_user_id_and_game_ids(games.map(&:id), current_user.id).pluck(:ranking_place)

    # FIXME soeren 19.09.15  das muss in einen Presenter
    # http://www.chartjs.org/
    data = {
        labels: labels,
        datasets: [

            {
                label: t(:your_ranking_per_game),
                fillColor: "rgba(151,187,205,0.2)",
                strokeColor: "rgba(151,187,205,1)",
                pointColor: "rgba(151,187,205,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(151,187,205,1)",
                data: user_rankings
            }
        ]
    }
    options = {
        responsive: true,
        bezierCurve: true,
        # Hack to get 1 at top, try Charts Version 2.0
        scaleOverride: true,
        scaleSteps: user_rankings.max - 1,
        scaleStepWidth: -1,
        scaleStartValue: user_rankings.max,

        showTooltips: false
    }
    render template: 'ranking_per_game/show', locals: {data: data.to_json,
                                                       options: options.to_json}
  end

end
