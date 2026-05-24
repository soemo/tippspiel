# frozen_string_literal: true

module Admin
  class StartCalculatingsController < Admin::BaseController
    def new
      time = Benchmark.realtime do
        ::Rankings::Recalculate.call
      end

      msg = "Berechnung erfolgreich in #{time.round(2)} seconds"
      Rails.logger.info msg
      flash[:notice] = msg
      redirect_to admin_games_path
    end
  end
end
