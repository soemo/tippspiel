# frozen_string_literal: true

namespace :results do

  # Friendly error reporter shared by the API-calling tasks. Keeps stacktraces
  # out of cron mailers and exits non-zero so a CI/cron job notices the failure.
  with_friendly_errors = lambda do |&block|
    begin
      block.call
    rescue Results::FootballDataClient::MissingTokenError => e
      warn "ERROR: FOOTBALL_DATA_API_TOKEN is not set (#{e.message})"
      exit 1
    rescue Results::FootballDataClient::ApiError => e
      warn "ERROR: football-data.org request failed (status=#{e.status || 'n/a'}): #{e.message}"
      exit 1
    end
  end

  desc 'Import finished game results from football-data.org. Sends summary email to ADMIN_EMAIL.'
  task import_finished: :environment do
    with_friendly_errors.call do
      result = Results::ImportFinishedGames.call

      Rails.logger.info(
        "results:import_finished — imported=#{result.imported.size} " \
        "discrepancies=#{result.discrepancies.size} unmatched=#{result.unmatched.size}"
      )

      if result.changes?
        ResultsMailer.import_summary(result).deliver_now
        Rails.logger.info('results:import_finished — summary email sent.')
      end
    end
  end

  desc 'Pre-tournament: walk all matches in FD and link them to our games. Writes football_data_match_id on unambiguous matches.'
  task backfill_football_data_ids: :environment do
    with_friendly_errors.call do
      entries = Results::BackfillFootballDataIds.call

      grouped = entries.group_by(&:status)

      %i[linked already_linked placeholder ambiguous unmatched time_mismatch tla_missing].each do |status|
        rows = grouped[status] || []
        puts ''
        puts "=== #{status.to_s.upcase} (#{rows.size}) ==="
        rows.each do |entry|
          fd   = entry.fd_match
          teams = "#{fd.home_tla} vs #{fd.away_tla}"
          game_info = entry.game ? " ↔ game ##{entry.game.id} (#{entry.game.round})" : ''
          detail    = entry.detail ? " — #{entry.detail}" : ''
          puts "  FD ##{fd.fd_id} #{teams} @ #{fd.utc_date}#{game_info}#{detail}"
        end
      end
    end
  end

  desc 'Backfill teams.football_data_tla from the seed map without touching games/tips/users. Safe to run on prod.'
  task backfill_tla: :environment do
    # Resolve the active tournament seed module via IS_WM/IS_EM so this task
    # works for WM 2026 and future tournaments without code changes.
    seed_module =
      if IS_WM
        require_relative '../../db/seeds/wm2026'
        Seeds::Wm2026
      elsif IS_EM
        # Update when an EM seed module is introduced (e.g. Seeds::Em2028).
        raise 'No seed module defined for IS_EM — add it here when creating db/seeds/em<year>.rb'
      else
        raise 'Neither IS_WM nor IS_EM is true — cannot resolve tournament seed module'
      end

    map = seed_module.football_data_tla_map
    updated = 0
    missing = []
    skipped_already_set = 0

    Team.find_each do |team|
      tla = map[team.name]
      if tla.nil?
        missing << team.name
        next
      end
      if team.football_data_tla == tla
        skipped_already_set += 1
        next
      end
      team.update_columns(football_data_tla: tla)
      puts "  #{team.name.ljust(25)} → #{tla}"
      updated += 1
    end

    puts ''
    puts "Updated:           #{updated}"
    puts "Already correct:   #{skipped_already_set}"
    if missing.any?
      puts "Teams without TLA in seed map (#{missing.size}):"
      missing.each { |n| puts "  - #{n}" }
    end
  end

end
