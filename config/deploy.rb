# um z.B. an den TOURNAMENT_NAME zu kommen
load File.expand_path('../initializers/01_constants.rb', __FILE__)

set :cap_tournament_name, TOURNAMENT_NAME

# your Uberspace username
set :user, 'soemo'

server 'taurus.uberspace.de', user: fetch(:user), roles: %w{app db web}

set :repository, "ssh://soemo@taurus.uberspace.de/home/soemo/git/tippspiel.git"
=begin
set :scm, :git
# ich nutze ein lokales git bei uberspace
set :repository, "file:///home/#{fetch(:user)}/git/tippspiel.git"
set :local_repository, "#{fetch(:user)}@taurus.uberspace.de:/home/#{fetch(:user)}/git/tippspiel.git"
set :branch,           'master'
set :scm_verbose,      false
set :deploy_via,       :remote_cache
set :copy_exclude,     [ '.git' ]
set :deploy_env,       'production'
=end
#SSHKit.config.command_map[:rake]  = "bundle exec rake"

#SSHKit.config.command_map[:rails] = "bundle exec rails"

set :passenger_max_pool_size, 2

set :keep_releases, 3

# Default value for :log_level is :debug
set :log_level, :info

# By default, Capistrano::Uberspace uses the ruby versions installed on your uberspace that matches your `.ruby-version` file.

# As of Capistrano 3.x, the `deploy:restart` task is not called automatically.
after 'deploy:finished', 'deploy:restart'

# Laden der Rezepte
Dir['config/deploy/recipes/*.rb'].each { |r| load(r) }
