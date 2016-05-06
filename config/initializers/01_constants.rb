# Anpassen fuer jeweiliges Tunier
TOURNAMENT_NAME = 'WM 2014'
IS_WM = true
IS_EM = !IS_WM

MAIL        = 'tippspiel@soemo.org'
ADMIN_EMAIL = 'soeren@mothes.org'

GROUP        = 'group'
QUARTERFINAL = 'quarterfinal'
SEMIFINAL    = 'semifinal'
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
  RSS_FEED_MAIN_URL = 'http://de.uefa.com'
  RSS_FEED_URL      = "#{RSS_FEED_MAIN_URL}/rssfeed/uefaeuro/rss.xml"

  ROUNDS = [GROUP, QUARTERFINAL, SEMIFINAL, FINAL]
  GROUPS = [GROUP_A, GROUP_B, GROUP_C, GROUP_D]
end

if IS_WM
  RSS_FEED_MAIN_URL = 'http://de.fifa.com'
  RSS_FEED_URL      = "#{RSS_FEED_MAIN_URL}/worldcup/news/rss.xml"

  ROUND_OF_16  = 'roundof16'
  PLACE_3      = 'place3'

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
