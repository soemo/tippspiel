module Admin
  class ResultImportsController < Admin::BaseController

    def new
      time = Benchmark.realtime { @result = ::Results::ImportFinishedGames.call }
      @duration = time.round(2)

      if @result.changes?
        begin
          ::ResultsMailer.import_summary(@result).deliver_now
        rescue StandardError => mail_error
          # Mail delivery failure must not hide the import result page — the
          # import itself succeeded. Log and surface a non-fatal warning.
          Rails.logger.error("ResultImportsController: mail delivery failed — #{mail_error.class}: #{mail_error.message}")
          flash[:warning] = I18n.t('admin.result_imports.mail_delivery_failed')
        end
      end

      Rails.logger.info(
        "Results::ImportFinishedGames done in #{@duration}s — " \
        "imported=#{@result.imported.size} discrepancies=#{@result.discrepancies.size} " \
        "unmatched=#{@result.unmatched.size}"
      )
      # No redirect — render the result page directly so the admin sees the
      # full breakdown (imported / discrepancies / unmatched) without having
      # to check the email.

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
      Rails.logger.error(e.backtrace&.first(20)&.join("\n"))
      flash[:error] = I18n.t('admin.result_imports.unexpected_error')
      redirect_to admin_games_path
    end

  end
end
