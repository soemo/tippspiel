# -*- encoding : utf-8 -*-

IS_WM = true
TOURNAMENT_NAME = 'WM 2014'

IS_EM = !IS_WM
# Anpassen fuer jeweiliges Tunier
# EM2012
#RSS_FEED_MAIN_URL = 'http://de.uefa.com'
#RSS_FEED_URL      = "#{RSS_FEED_MAIN_URL}/rssfeed/uefaeuro/rss.xml"
# WM2014
RSS_FEED_MAIN_URL = 'http://de.fifa.com'
RSS_FEED_URL      = "#{RSS_FEED_MAIN_URL}/worldcup/news/rss.xml"

# Wird im FootieFoxUpdateGames benutzt
RESULT_URL = 'http://api.footiefox.com/leagues/101/base.json'

MAIL        = 'tippspiel@soemo.org'
ADMIN_EMAIL = 'soeren@mothes.org'

SIDEBAR_EXTERN_LINKS = [
    {:title => 'sportschau.de', :url => 'http://www.sportschau.de/fifawm2014/index.html'},
    {:title => 'FIFA', :url => 'http://de.fifa.com/worldcup/index.html'},
    {:title => 'Wikipedia', :url => 'http://de.wikipedia.org/wiki/Fu%C3%9Fball-Weltmeisterschaft_2014'},
    {:title => 'Interaktiver Spielplan (ZDF)', :url => 'http://spielplan-wm2014.zdf.de/'},
]


MAIN_NAV_USER_SUBMENU_ID = 'current_user_sub_menu'
