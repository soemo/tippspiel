# frozen_string_literal: true

# Load constants (e.g. DEPLOYMENT_NAME) for use in Capistrano config
load File.expand_path('initializers/01_constants.rb', __dir__)

set :cap_tournament_name, DEPLOYMENT_NAME

# your Uberspace username
set :user, 'soemo'

set :stage, 'production'
# set :scm, :git

set :repo_url, 'git@github.com:soemo/tippspiel.git'

server 'farbauti.uberspace.de', user: fetch(:user), roles: %w[app db web]

set :ssh_options, { forward_agent: true }

SSHKit.config.command_map[:rake]  = 'bundle exec rake'

SSHKit.config.command_map[:rails] = 'bundle exec rails'

set :rails_env, 'production'

set :passenger_max_pool_size, 2

set :keep_releases, 3

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, fetch(:linked_files, []).push('config/database.yml', '.env')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'public/system')

# Default value for :log_level is :debug
set :log_level, :debug

set :bundle_flags, ''

# Force Bundler to install gems from source on the server instead of using
# precompiled native binaries. Required because Uberspace runs CentOS 7
# (glibc 2.17), and nokogiri's precompiled x86_64-linux-gnu binary needs
# glibc >= 2.28. Compiling from source uses nokogiri's vendored libxml2/libxslt.
# Adds ~30-90s to each deploy.
set :bundle_config, { force_ruby_platform: true }

# By default, Capistrano::Uberspace uses the ruby versions installed on your uberspace that matches your `.ruby-version` file.

# As of Capistrano 3.x, the `deploy:restart` task is not called automatically.
after 'deploy:finished', 'deploy:restart'

# Laden der Rezepte
Dir['config/deploy/recipes/*.rb'].each { |r| load(r) }
