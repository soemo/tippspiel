# frozen_string_literal: true

# Anpassen fuer jeweiliges Tunier
# Used in config/deploy.rb to derive the database name suffix (e.g. "wm_2026").
# Not for display — use I18n.t('tournament_name') in views/presenters instead.
DEPLOYMENT_NAME = 'wm_2026'
IS_WM = true
IS_EM = !IS_WM

MAIL        = ENV.fetch('MAIL', nil)
ADMIN_EMAIL = ENV.fetch('ADMIN_EMAIL', nil)
WEBSITE_URL = ENV.fetch('WEBSITE_URL', nil)

GROUP        = 'group'
ROUND_OF_32  = 'roundof32'
ROUND_OF_16  = 'roundof16'
QUARTERFINAL = 'quarterfinal'
SEMIFINAL    = 'semifinal'
PLACE_3      = 'place3'
FINAL        = 'final'

GROUP_A      = 'A'
GROUP_B      = 'B'
GROUP_C      = 'C'
GROUP_D      = 'D'
GROUP_E      = 'E'
GROUP_F      = 'F'
GROUP_G      = 'G'
GROUP_H      = 'H'
GROUP_I      = 'I'
GROUP_J      = 'J'
GROUP_K      = 'K'
GROUP_L      = 'L'

if IS_EM
  ROUNDS = [GROUP, ROUND_OF_16, QUARTERFINAL, SEMIFINAL, FINAL].freeze
  GROUPS = [GROUP_A, GROUP_B, GROUP_C, GROUP_D, GROUP_E, GROUP_F].freeze
  # football-data.org competition code for the UEFA European Championship.
  # See https://docs.football-data.org/general/v4/lookup_tables.html
  FOOTBALL_DATA_COMPETITION_CODE = 'EC'
end

if IS_WM
  ROUNDS = [GROUP, ROUND_OF_32, ROUND_OF_16, QUARTERFINAL, SEMIFINAL, PLACE_3, FINAL].freeze
  GROUPS = [GROUP_A, GROUP_B, GROUP_C, GROUP_D, GROUP_E, GROUP_F, GROUP_G, GROUP_H,
            GROUP_I, GROUP_J, GROUP_K, GROUP_L].freeze
  # football-data.org competition code for the FIFA World Cup.
  # See https://docs.football-data.org/general/v4/lookup_tables.html
  FOOTBALL_DATA_COMPETITION_CODE = 'WC'
end

POINTS_TO_CSS_CLASS =
  { '8' => 'eight-point-background-color',
    '5' => 'five-point-background-color',
    '4' => 'four-point-background-color',
    '3' => 'three-point-background-color',
    '0' => 'null-point-background-color' }.freeze

BONUS_OPTIONS_WHEN_WILL_THE_FIRST_GOAL = {
  1 => 'in_the_first_half',
  2 => 'in_the_second_half',
  3 => 'in_the_extra_time',
  4 => 'in_the_penalty'
}.freeze

URL_SCOPES = {
  admin: 'admin',
  bonus: 'bonus',
  comparetips: 'comparetips',
  help: 'help',
  notes: 'notes',
  ranking: 'ranking',
  user: 'user'
}.freeze

FILTER_DEFAULT = 'all'
FILTER_TODAY = 'today'
FILTER_FUTURE = 'future'
FILTER_CATEGORIES = [FILTER_DEFAULT, FILTER_TODAY, FILTER_FUTURE].freeze

# Mixitup filter class prefixes for group / round filters.
# The actual filter values are derived from tournament data (GROUPS, ROUNDS).
FILTER_GROUP_PREFIX = 'group-'
FILTER_ROUND_PREFIX = 'round-'

SUPPORTED_LOCALES = %w[de en].freeze
