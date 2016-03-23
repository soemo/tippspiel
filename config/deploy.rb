# um z.B. an den TOURNAMENT_NAME zu kommen
load File.expand_path('../initializers/01_constants.rb', __FILE__)

set :cap_tournament_name, TOURNAMENT_NAME

# your Uberspace username
set :user, 'soemo'

server 'sabic.uberspace.de', user: fetch(:user), roles: %w{app db web}

set :repo_url, "file:///home/#{fetch(:user)}/git/tippspiel.git"

SSHKit.config.command_map[:rake]  = "bundle exec rake"

SSHKit.config.command_map[:rails] = "bundle exec rails"

set :rails_env, 'production'

set :default_env, { path: "/package/host/localhost/ruby-#{fetch(:ruby_version, -> { get_ruby_version })}/bin:$PATH" }

set :passenger_max_pool_size, 2

set :keep_releases, 3

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'public/system')

# Default value for :log_level is :debug
set :log_level, :info

set :bundle_flags, '--deployment --quiet'

# By default, Capistrano::Uberspace uses the ruby versions installed on your uberspace that matches your `.ruby-version` file.

# As of Capistrano 3.x, the `deploy:restart` task is not called automatically.
after 'deploy:finished', 'deploy:restart'

# Laden der Rezepte
Dir['config/deploy/recipes/*.rb'].each { |r| load(r) }
