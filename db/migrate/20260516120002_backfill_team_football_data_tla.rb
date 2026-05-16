# Data migration: write teams.football_data_tla on existing rows.
#
# The schema migration (20260516120001_add_football_data_tla_to_teams) only
# adds the column. On databases that already have teams in them (beta, prod,
# and any local DB not freshly seeded), the column stays NULL until something
# fills it.
#
# This migration backfills the column. It is:
#   - idempotent — rows that already match are skipped
#   - non-destructive — only `football_data_tla` is touched, via update_columns
#   - safe to remove later — once every environment has run it, the file can
#     be deleted (or commented out) without consequence
#
# The TLA map is inlined here on purpose: data migrations are historical
# snapshots and must remain runnable even if db/seeds/wm2026.rb is later
# moved, renamed, or extended. The seeds file keeps its own copy for
# fresh DBs and for the (now redundant) `bin/rails results:backfill_tla` task.
class BackfillTeamFootballDataTla < ActiveRecord::Migration[6.1]

  # Frozen snapshot of Seeds::Wm2026.football_data_tla_map as of 2026-05-16.
  # Do NOT update this when the seed map changes — write a new migration.
  TLA_MAP = {
    'Ägypten'               => 'EGY',
    'Albanien'              => 'ALB',
    'Algerien'              => 'ALG',
    'Argentinien'           => 'ARG',
    'Australien'            => 'AUS',
    'Belgien'               => 'BEL',
    'Bosnien-Herzegowina'   => 'BIH',
    'Brasilien'             => 'BRA',
    'Chile'                 => 'CHI',
    'Costa Rica'            => 'CRC',
    'Curaçao'               => 'CUW',
    'Dänemark'              => 'DEN',
    'Deutschland'           => 'GER',
    'DR Kongo'              => 'COD',
    'Ecuador'               => 'ECU',
    'Elfenbeinküste'        => 'CIV',
    'England'               => 'ENG',
    'Finnland'              => 'FIN',
    'Frankreich'            => 'FRA',
    'Georgien'              => 'GEO',
    'Ghana'                 => 'GHA',
    'Griechenland'          => 'GRE',
    'Haiti'                 => 'HAI',
    'Honduras'              => 'HON',
    'Iran'                  => 'IRN',
    'Irak'                  => 'IRQ',
    'Irland'                => 'IRL',
    'Island'                => 'ISL',
    'Italien'               => 'ITA',
    'Japan'                 => 'JPN',
    'Jordanien'             => 'JOR',
    'Kamerun'               => 'CMR',
    'Kanada'                => 'CAN',
    'Kap Verde'             => 'CPV',
    'Katar'                 => 'QAT',
    'Kolumbien'             => 'COL',
    'Kroatien'              => 'CRO',
    'Marokko'               => 'MAR',
    'Mexiko'                => 'MEX',
    'Neuseeland'            => 'NZL',
    'Niederlande'           => 'NED',
    'Nigeria'               => 'NGA',
    'Nordirland'            => 'NIR',
    'Nordmazedonien'        => 'MKD',
    'Norwegen'              => 'NOR',
    'Österreich'            => 'AUT',
    'Panama'                => 'PAN',
    'Paraguay'              => 'PAR',
    'Peru'                  => 'PER',
    'Polen'                 => 'POL',
    'Portugal'              => 'POR',
    'Rumänien'              => 'ROU',
    'Russland'              => 'RUS',
    'Saudi-Arabien'         => 'KSA',
    'Schottland'            => 'SCO',
    'Schweden'              => 'SWE',
    'Schweiz'               => 'SUI',
    'Senegal'               => 'SEN',
    'Serbien'               => 'SRB',
    'Slowakei'              => 'SVK',
    'Slowenien'             => 'SVN',
    'Spanien'               => 'ESP',
    'Südkorea'              => 'KOR',
    'Südafrika'             => 'RSA',
    'Tschechien'            => 'CZE',
    'Tunesien'              => 'TUN',
    'Türkei'                => 'TUR',
    'Ukraine'               => 'UKR',
    'Ungarn'                => 'HUN',
    'Uruguay'               => 'URU',
    'USA'                   => 'USA',
    'Usbekistan'            => 'UZB',
    'Wales'                 => 'WAL'
  }.freeze

  def up
    Team.reset_column_information

    updated = 0
    missing = []

    Team.find_each do |team|
      tla = TLA_MAP[team.name]
      if tla.nil?
        missing << team.name
        next
      end
      next if team.football_data_tla == tla

      team.update_columns(football_data_tla: tla)
      updated += 1
    end

    say "Backfilled football_data_tla on #{updated} team(s)."
    if missing.any?
      say "WARNING: #{missing.size} team(s) had no TLA in the snapshot map: #{missing.join(', ')}"
    end
  end

  def down
    # Reversible no-op: rolling back the schema migration that adds the column
    # already removes the data. Nothing extra to undo here.
  end

end
