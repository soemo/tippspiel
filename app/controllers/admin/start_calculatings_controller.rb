module Admin
  class StartCalculatingsController < Admin::BaseController

    def new
      time = Benchmark.realtime do
        ActiveRecord::Base.transaction do
          ::Tips::UpdatePoints.call
          ::Users::UpdatePoints.call
          ::Users::UpdateRankingPerGame.call
        end
      end

      msg = "Berechnung erfolgreich in #{time.round(2)} seconds"
      Rails.logger.info msg
      flash[:notice] = msg
      redirect_to admin_games_path
    end

  end
end
