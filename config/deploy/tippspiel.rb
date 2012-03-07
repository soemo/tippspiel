role :app, "tippspiel.soemo.org"
role :web, "tippspiel.soemo.org"
role :db,  "tippspiel.soemo.org", :primary => true

set :user, "soemo"
set :password, nil  # wird auf der Konsole angegeben
set :application, "tippspiel.soemo.org"
set :deploy_to, "/var/www/virtual/#{user}/#{application}"

set :customizing_dir, "em2012"

# aktuell nutzt ich ruby 1.8.7 ohne rvm
set :ruby_path, "/package/host/localhost/ruby-1.8.7"
set :path, "$HOME/bin/:/.gem/ruby/1.8/bin:/package/host/localhost/ruby-1.8.7/bin/:$PATH:"