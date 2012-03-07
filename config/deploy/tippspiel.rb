role :app, "tippspiel.soemo.org"
role :web, "tippspiel.soemo.org"
role :db,  "tippspiel.soemo.org", :primary => true

set :user, "soemo"
set :password, nil  # wird auf der Konsole angegeben
set :application, "tippspiel.soemo.org"
set :deploy_to, "/var/www/virtual/#{user}/#{application}"

set :customizing_dir, "em2012"