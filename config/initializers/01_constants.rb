# Anpassen fuer jeweiliges Tunier
TOURNAMENT_NAME = 'EM 2016'
IS_WM = false
IS_EM = !IS_WM

MAIL        = 'tippspiel@soemo.org'
ADMIN_EMAIL = 'soeren@mothes.org'

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
  # bei der EM 2916 war hier eine veraltete Uberschrift und die Tage der Post stimmten nicht, daher wurde ein andererRSS Feed genutzt
  #RSS_FEED_MAIN_URL = 'http://de.uefa.com'
  #RSS_FEED_URL      = "#{RSS_FEED_MAIN_URL}/rssfeed/uefaeuro/rss.xml"
  RSS_FEED_MAIN_URL = 'http://rss.kicker.de'
  RSS_FEED_URL      = "#{RSS_FEED_MAIN_URL}/news/em"

  ROUNDS = [GROUP, ROUND_OF_16, QUARTERFINAL, SEMIFINAL, FINAL]
  GROUPS = [GROUP_A, GROUP_B, GROUP_C, GROUP_D, GROUP_E, GROUP_F]
end

if IS_WM
  RSS_FEED_MAIN_URL = 'http://de.fifa.com'
  RSS_FEED_URL      = "#{RSS_FEED_MAIN_URL}/worldcup/news/rss.xml"

  ROUNDS = [GROUP, ROUND_OF_16, QUARTERFINAL, SEMIFINAL, PLACE_3, FINAL]
  GROUPS = [GROUP_A, GROUP_B, GROUP_C, GROUP_D, GROUP_E, GROUP_F, GROUP_G, GROUP_H]
end


POINTS_TO_CSS_CLASS =
    {'8' => 'eight-point-background-color',
     '5' => 'five-point-background-color',
     '4' => 'four-point-background-color',
     '3' => 'three-point-background-color',
     '0' => 'null-point-background-color'}


URL_SCOPES = {
    admin: 'admin'.freeze,
    'comparetips': 'comparetips'.freeze,
    help: 'help'.freeze,
    notes: 'notes'.freeze,
    ranking: 'ranking'.freeze,
    tips: 'tips'.freeze,
    user: 'user'.freeze,
}.freeze

FILTER_DEFAULT = 'all'.freeze
FILTER_TODAY = 'today'.freeze
FILTER_FUTURE = 'future'.freeze
FILTER_CATEGORIES = [FILTER_DEFAULT, FILTER_TODAY, FILTER_FUTURE]
