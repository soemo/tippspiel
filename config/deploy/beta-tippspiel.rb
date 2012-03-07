role :app, "beta-tippspiel.soemo.org"
role :web, "beta-tippspiel.soemo.org"
role :db,  "beta-tippspiel.soemo.org", :primary => true

set :user, "soemo"
set :password, nil  # wird auf der Konsole angegeben
set :application, "beta-tippspiel.soemo.org"
set :deploy_to, "/var/www/virtual/#{user}/#{application}"

set :customizing_dir, "beta-em2012"

# aktuell nutzt ich ruby 1.8.7 ohne rvm
set :default_environment, {
  'PATH' => "$HOME/.gem/ruby/1.8/bin:/package/host/localhost/ruby-1.8.7/bin/:$PATH:"
}