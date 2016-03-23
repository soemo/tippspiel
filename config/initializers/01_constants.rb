# Anpassen fuer jeweiliges Tunier
IS_WM = true
TOURNAMENT_NAME = 'WM 2014'
IS_EM = !IS_WM


# Wird im FootieFoxUpdateGames benutzt
RESULT_URL = 'http://api.footiefox.com/leagues/101/base.json'

MAIL        = 'tippspiel@soemo.org'
ADMIN_EMAIL = 'soeren@mothes.org'

MAIN_NAV_USER_SUBMENU_ID = 'current_user_sub_menu'

GROUP        = 'group'
QUARTERFINAL = 'quarterfinal'
SEMIFINAL    = 'semifinal'
FINAL        = 'final'

GROUP_A      = 'A'
GROUP_B      = 'B'
GROUP_C      = 'C'
GROUP_D      = 'D'

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

  GROUP_E      = 'E'
  GROUP_F      = 'F'
  GROUP_G      = 'G'
  GROUP_H      = 'H'

  GROUPS = [GROUP_A, GROUP_B, GROUP_C, GROUP_D, GROUP_E, GROUP_F, GROUP_G, GROUP_H]
end


POINTS_TO_CSS_CLASS =
    {'8' => 'eight-point-background-color',
     '5' => 'five-point-background-color',
     '4' => 'four-point-background-color',
     '3' => 'three-point-background-color',
     '0' => 'null-point-background-color'}
