set :stages, %w(tippspiel beta-tippspiel)
set :default_stage, "beta-tippspiel"
require 'capistrano/ext/multistage'

set :repository, "ssh://soemo@taurus.uberspace.de/home/soemo/git/tippspiel.git"
set :branch, "master"
set :scm, :git
set :scm_verbose, true
# siehe http://help.github.com/deploy-with-capistrano/
# oder https://github.com/capistrano/capistrano/wiki/2.x-From-The-Beginning
## TODO soeren brauche ich das set :scm_passphrase, "p@ssw0rd"  # The deploy user's password

### General Settings ( don't change them please )

# run in pty to allow remote commands via ssh
default_run_options[:pty] = true

# don't use sudo it's not necessary
set :use_sudo, false

set :deploy_via, :remote_cache
set :deploy_env, 'production'

set :keep_releases, 5
after "deploy", "deploy:cleanup"

### ## ## ## ## ## ## ## ## ## ## ## ## ##
### Dont Modify following Tasks!
###

# TODO soeren 07.03.12 start stop fuer passenger

namespace :db do
 desc "run db:seed"
 task :run_seed, :roles => [:web] do
   run "cd #{current_release} && RAILS_ENV=production #{ruby_path}/bin/ruby -S bundle exec rake db:seed"
 end
end

namespace :deploy do
 desc "set Versionnumber and Build-Date. Needs Rake Task APPLICATION:set_version (APPLICATION is the namespace)"
 task :set_version_and_date, :roles => [:web] do
   run "cd #{release_path} && #{ruby_path}/bin/ruby -S bundle exec rake tippspiel:set_version"
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

namespace :deploy do
 desc "bundle install --deployment --without development test"
 task :bundle_install, :roles => [:web] do
   #run "cd #{release_path} && #{ruby_path}/bin/ruby -S bundle install --deployment --without development test"
   run "ruby -v"
   run "#{ruby_path}/bin/ruby -v"
 end
end
after "deploy:finalize_update", "deploy:bundle_install"

# # TODO soeren wieder aktivieren
#namespace :deploy do
#  desc 'Precompiling Assets'
#  task :precompile_assets, :roles => :app do
#    run "cd #{release_path} && RAILS_ENV=production #{ruby_path}/bin/ruby -S bundle exec rake assets:precompile"
#    EOF
#  end
#  # Generate all the stylesheets manually (from their Sass templates) before each restart.
#  after 'deploy:update_code', 'deploy:precompile_assets'
#end

## # # FIXME soeren 05.03.12 abgleichen was ich brauche
#namespace :deploy do
#
#  desc "Restarting mod_rails with restart.txt"
#  task :restart, :roles => :app, :except => { :no_release => true } do
#    run "touch #{current_path}/tmp/restart.txt"
#  end
#
#end



