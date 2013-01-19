# -*- encoding : utf-8 -*-

set :stages, %w(tippspiel beta-tippspiel)
set :default_stage, "beta-tippspiel"

require "capistrano/ext/multistage"

# bundle dir umsetzen soll in jedem Release neu gemacht werden (nicht im shared_path)
set(:bundle_dir) {File.join(fetch(:release_path), 'bundle')}
set(:bundle_flags) { "--deployment" } ## FIXME soeren 19.01.13 " --quiet"

# include uberspacify base recipes
require 'uberspacify/base'

# comment this if you don't use MySQL
require 'uberspacify/mysql'

# the Uberspace server you are on
server 'taurus.uberspace.de', :web, :app, :db, :primary => true

# your Uberspace username
set :user, 'soemo'


# the repo where your code is hosted
set :scm, :git
#set :repository, 'https://github.com/yeah/dummyapp.git'
# ich nutze ein lokales git bei uberspace
set :repository,       "/home/#{user}/git/tippspiel.git"
set :local_repository, "#{user}@taurus.uberspace.de:git/tippspiel.git"
set :scm_verbose,      true
set :deploy_via,       :remote_cache
set :deploy_env,       'production'

# By default, Ruby Enterprise Edition 1.8.7 is used for Uberspace. If you
# prefer Ruby 1.9 or any other version, please refer to the RVM documentation
# at https://rvm.io/integration/capistrano/ and set this variable.
set :rvm_ruby_string, "ruby-1.9.3-p362"

set :rake, "bundle exec rake"


# auf lokales git zugreifen
#set :repository, "/home/soemo/git/tippspiel.git"
#set :local_repository, "soemo@taurus.uberspace.de:git/tippspiel.git"
# remote
#set :repository, "ssh://soemo@taurus.uberspace.de/home/soemo/git/tippspiel.git"

#set :scm, :git
#set :scm_verbose, true
# siehe http://help.github.com/deploy-with-capistrano/
# oder https://github.com/capistrano/capistrano/wiki/2.x-From-The-Beginning
## TODO soeren brauche ich das set :scm_passphrase, "p@ssw0rd"  # The deploy user's password

### General Settings ( don't change them please )

set :keep_releases, 5



### ## ## ## ## ## ## ## ## ## ## ## ## ##
### Don't Modify following Tasks!

namespace :deploy do
  desc "set Versionnumber and Build-Date. Needs Rake Task APPLICATION:set_version (APPLICATION is the namespace)"
  task :set_version_and_date, :roles => [:web] do
    run "cd #{release_path} && bundle exec rake tippspiel:set_version"
  end
end
after "deploy:update_code", "deploy:set_version_and_date"

namespace :deploy do
  desc "Customizing und Branding der reinen Ruby on Rails Anwendung"
  task :customizing do
    customizing_parent_dir = "#{current_release}/customizing/"
    customizing_path = "#{current_release}/customizing/#{customizing_dir}"
    run "cp -r -v #{customizing_path}/* #{current_release}"
    run "rm -rf #{customizing_parent_dir}"
  end
end
after "deploy:finalize_update", "deploy:customizing"

namespace :db do
  desc "run db:seed"
  task :run_seed, :roles => [:web] do
    run "cd #{current_release} && RAILS_ENV=production bundle exec rake db:seed"
  end
end

# FIXME soeren 19.01.13 --max-pool-size 2"
# OLD

#namespace :deploy do
#  desc "bundle exec passenger start"
#  task :start, :roles => :app, :except => {:no_release => true} do
#    run "cd #{current_path} && bundle exec passenger start #{current_path} -a 127.0.0.1 -p #{standalone_passenger_port} -d -e production --max-pool-size 2"
#  end
#  desc "bundle exec passenger stop"
#  task :stop, :roles => :app, :except => {:no_release => true} do
#    #run "cd #{current_path} && bundle exec passenger stop --pid-file tmp/pids/passenger.pid"
#    run "cd #{current_path} && bundle exec passenger stop -p #{standalone_passenger_port}"
#  end
#  desc "Restarting mod_rails with restart.txt"
#  task :restart, :roles => :app, :except => {:no_release => true} do
#    run "touch #{File.join(current_path, 'tmp', 'restart.txt')}"
#  end
#end
#
#
#namespace :db do
#  desc "run db:seed"
#  task :run_seed, :roles => [:web] do
#    run "cd #{current_release} && RAILS_ENV=production bundle exec rake db:seed"
#  end
#end
#
#namespace :deploy do
#  desc "set Versionnumber and Build-Date. Needs Rake Task APPLICATION:set_version (APPLICATION is the namespace)"
#  task :set_version_and_date, :roles => [:web] do
#    run "cd #{release_path} && bundle exec rake tippspiel:set_version"
#  end
#end
#after "deploy:update_code", "deploy:set_version_and_date"
#
#namespace :deploy do
#  desc "Customizing und Branding der reinen Ruby on Rails Anwendung"
#  task :customizing do
#    customizing_parent_dir = "#{current_release}/customizing/"
#    customizing_path = "#{current_release}/customizing/#{customizing_dir}"
#    run "cp -r -v #{customizing_path}/* #{current_release}"
#    run "rm -rf #{customizing_parent_dir}"
#  end
#end
#after "deploy:finalize_update", "deploy:customizing"
#
#namespace :deploy do
#  desc "bundle install --deployment --without development test"
#  task :bundle_install, :roles => [:web] do
#    run "cd #{release_path} && bundle install --deployment --without development test"
#  end
#end
#after "deploy:finalize_update", "deploy:bundle_install"
#
#namespace :deploy do
#  desc 'Precompiling Assets'
#  task :precompile_assets, :roles => :app do
#    run "cd #{release_path} && RAILS_ENV=production bundle exec rake assets:precompile"
#  end
#  # Generate all the stylesheets manually (from their Sass templates) before each restart.
#  after 'deploy:update_code', 'deploy:precompile_assets'
#end





