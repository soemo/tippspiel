# Anpassen fuer jeweiliges Tunier
TOURNAMENT_NAME = 'EM 2024'
IS_WM = false
IS_EM = !IS_WM

MAIL        = ENV['MAIL']
ADMIN_EMAIL = ENV['ADMIN_EMAIL']
WEBSITE_URL = ENV['WEBSITE_URL']

GROUP        = 'group'
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

if IS_EM
  ROUNDS = [GROUP, ROUND_OF_16, QUARTERFINAL, SEMIFINAL, FINAL]
  GROUPS = [GROUP_A, GROUP_B, GROUP_C, GROUP_D, GROUP_E, GROUP_F]
end

if IS_WM
  ROUNDS = [GROUP, ROUND_OF_16, QUARTERFINAL, SEMIFINAL, PLACE_3, FINAL]
  GROUPS = [GROUP_A, GROUP_B, GROUP_C, GROUP_D, GROUP_E, GROUP_F, GROUP_G, GROUP_H]
end

POINTS_TO_CSS_CLASS =
    {'8' => 'eight-point-background-color',
     '5' => 'five-point-background-color',
     '4' => 'four-point-background-color',
     '3' => 'three-point-background-color',
     '0' => 'null-point-background-color'
}.freeze

BONUS_OPTIONS_WHEN_WILL_THE_FIRST_GOAL = {
    1 => 'in_the_first_half',
    2 => 'in_the_second_half',
    3 => 'in_the_extra_time',
    4 => 'in_the_penalty',
}.freeze

### set this values for the bonus questions
### maybe later I use a database setting model
BONUS_ANSWER_HOW_MANY_GOALS=nil
BONUS_ANSWER_WHEN_WILL_THE_FIRST_GOAL=nil # add key from BONUS_OPTIONS_WHEN_WILL_THE_FIRST_GOAL

URL_SCOPES = {
    admin: 'admin'.freeze,
    bonus: 'bonus'.freeze,
    'comparetips': 'comparetips'.freeze,
    help: 'help'.freeze,
    notes: 'notes'.freeze,
    ranking: 'ranking'.freeze,
    user: 'user'.freeze,
}.freeze

FILTER_DEFAULT = 'all'.freeze
FILTER_TODAY = 'today'.freeze
FILTER_FUTURE = 'future'.freeze
FILTER_CATEGORIES = [FILTER_DEFAULT, FILTER_TODAY, FILTER_FUTURE]
