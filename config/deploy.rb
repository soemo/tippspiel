# -*- encoding : utf-8 -*-

set :stages, %w(tippspiel beta-tippspiel)
set :default_stage, 'beta-tippspiel'

set :cap_tournament_name, 'WM 2014'# TOURNAMENT_NAME # TODO soeren 22.04.14 geht das besser

require "capistrano/ext/multistage"

# siehe https://wiki.uberspace.de/development:ruby#nokogiri
before "bundle:install" do
  run "cd #{fetch(:latest_release)} && bundle config build.nokogiri --with-xml2-lib=$HOME/.toast/armed/lib --with-xml2-include=$HOME/.toast/armed/include/libxml2 --with-xslt-dir=$HOME/.toast/armed"
end

# INFO: bundle der gems wird in shared Verzeichnis gelegt. Daher wercden nur neue Gens installiert
set(:bundle_flags) { "--deployment --quiet" }

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
set :repository, "file:///home/#{user}/git/tippspiel.git"
set :local_repository, "file://."
set :scm_verbose,      true
set :deploy_via,       :export
set :deploy_env,       'production'

# By default, Ruby Enterprise Edition 1.8.7 is used for Uberspace. If you
# prefer Ruby 1.9 or any other version, please refer to the RVM documentation
# at https://rvm.io/integration/capistrano/ and set this variable.
set :rvm_ruby_string, "ruby-1.9.3-p362"

set :rake, "bundle exec rake"

set :passenger_max_pool_size, 2

set :keep_releases, 3



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

after "deploy:restart", "deploy:cleanup"





