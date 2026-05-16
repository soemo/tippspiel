# encoding: utf-8
#
# Cron schedule for automatic result imports (whenever gem).
#
# The crontab is installed/updated automatically on production deploys by the
# Capistrano recipe in config/deploy/recipes/own_deploy.rb — no manual
# step needed. The recipe skips beta deploys.
#
# To inspect or manually update on the server:
#   bundle exec whenever --update-crontab tippspiel.soemo.org \
#     --set environment=production
#
# To remove entries at end of tournament:
#   bundle exec whenever --clear-crontab tippspiel.soemo.org
#
# Verify with:
#   whenever            # prints the cron table
#   crontab -l          # shows live entries on the server
#
# Server timezone: Europe/Berlin (CEST/CET) — hours below are German local time.
#
# WM 2026 game windows (German time, UTC+2 in summer):
#   US East Coast kickoffs  → finish ~21:00–23:00 CEST
#   US Central kickoffs     → finish ~23:00–01:00 CEST
#   US West Coast kickoffs  → finish ~03:00–05:00 CEST
#
# Strategy: run every 15 min during two windows that together cover 16:00–06:59,
# plus a daily 08:00 safety run to catch any overnight FD corrections.
# The 07:00–15:59 window is silent — no WM games are expected there.
# Runs that find nothing new are silent no-ops (no email, no DB writes,
# one cheap API call — free tier limit is 10 req/min, no daily cap).
#
# Logging: the rake task writes to Rails.logger (log/production.log),
# which is already managed by the app. Stdout from cron is discarded
# (/dev/null) since it's redundant; unexpected stderr (e.g. bundler
# errors) is appended to log/production.log so it doesn't go to the
# server mail spool.
set :output, error: 'log/production.log', standard: '/dev/null'

# Safety run: catches overnight FD corrections and any edge cases.
every 1.day, at: '8:00 am' do
  rake 'results:import_finished'
end

# Evening/night window: covers US East + Central Coast games (16:00–23:59 CEST).
every '*/15 16-23 * * *' do
  rake 'results:import_finished'
end

# Late night / early morning window: covers US West Coast games (00:00–06:59 CEST).
every '*/15 0-6 * * *' do
  rake 'results:import_finished'
end
