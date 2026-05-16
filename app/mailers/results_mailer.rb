# frozen_string_literal: true

# Sends a summary email to the admin after a result-import run.
# Only ever delivers when there's something to report (imported games or
# discrepancies). Unmatched-only runs are noise and are not mailed.
class ResultsMailer < ApplicationMailer

  # result: a Results::ImportFinishedGames::Result
  def import_summary(result)
    @result        = result
    @imported      = result.imported
    @discrepancies = result.discrepancies
    @unmatched     = result.unmatched

    subject = build_subject(result)

    mail(
      to:      ADMIN_EMAIL,
      subject: subject
    )
  end

  private

  def build_subject(result)
    parts = []
    parts << "#{result.imported.size} imported"      if result.imported.any?
    parts << "#{result.discrepancies.size} discrepancies" if result.discrepancies.any?
    "[Tippspiel] Result import: #{parts.join(', ')}"
  end

end
