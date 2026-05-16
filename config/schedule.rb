# encoding: utf-8
#
# Cron schedule for automatic result imports (whenever gem).
#
# Deploy/update with:
#   whenever --update-crontab --set environment=production
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
# Runs that find nothing new are silent no-ops (no email, one cheap API call).

set :output, 'log/cron.log'
set :environment, :production

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
