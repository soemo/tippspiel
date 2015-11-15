load 'config/initializers/01_constants' # um z.B. an den TOURNAMENT_NAME zu kommen

set :cap_tournament_name, TOURNAMENT_NAME

# your Uberspace username
set :user, 'soemo'

server 'taurus.uberspace.de', user: fetch(:user), roles: %w{app db web}

set :scm, :git
# ich nutze ein lokales git bei uberspace
set :repository, "file:///home/#{fetch(:user)}/git/tippspiel.git"
set :local_repository, "#{fetch(:user)}@taurus.uberspace.de:/home/#{fetch(:user)}/git/tippspiel.git"
set :branch,           'master'
set :scm_verbose,      false
set :deploy_via,       :remote_cache
set :copy_exclude,     [ '.git' ]
set :deploy_env,       'production'

set :rake, "bundle exec rake"

set :passenger_max_pool_size, 2

set :keep_releases, 3

# By default, Capistrano::Uberspace uses the ruby versions installed on your uberspace that matches your `.ruby-version` file.

# Laden der Rezepte
Dir['config/deploy/recipes/*.rb'].each { |r| load(r) }
