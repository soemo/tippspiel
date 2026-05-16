module Admin
  class ResultImportsController < Admin::BaseController

    def new
      result = nil
      time = Benchmark.realtime { result = ::Results::ImportFinishedGames.call }

      if result.changes?
        ::ResultsMailer.import_summary(result).deliver_now
      end

      flash[:notice] = I18n.t(
        'admin.result_imports.success',
        time:          time.round(2),
        imported:      result.imported.size,
        discrepancies: result.discrepancies.size,
        unmatched:     result.unmatched.size
      )
      Rails.logger.info(
        "Results::ImportFinishedGames done in #{time.round(2)}s — " \
        "imported=#{result.imported.size} discrepancies=#{result.discrepancies.size} " \
        "unmatched=#{result.unmatched.size}"
      )
      redirect_to admin_games_path

    rescue ::Results::FootballDataClient::MissingTokenError => e
      Rails.logger.error("ResultImportsController: missing token — #{e.message}")
      flash[:error] = I18n.t('admin.result_imports.missing_token')
      redirect_to admin_games_path

    rescue ::Results::FootballDataClient::ApiError => e
      Rails.logger.error("ResultImportsController: API error #{e.status} — #{e.message}")
      flash[:error] = I18n.t('admin.result_imports.api_error', status: e.status)
      redirect_to admin_games_path

    rescue StandardError => e
      Rails.logger.error("ResultImportsController: unexpected error — #{e.class}: #{e.message}")
      Rails.logger.error(e.backtrace.first(20).join("\n"))
      flash[:error] = I18n.t('admin.result_imports.unexpected_error')
      redirect_to admin_games_path
    end

  end
end
