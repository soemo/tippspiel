set :stages, %w(tippspiel beta-tippspiel)
set :default_stage, "beta-tippspiel"

require "capistrano/ext/multistage"
require "bundler/capistrano"

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

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end


namespace :db do
  desc "run db:seed"
  task :run_seed, :roles => [:web] do
    run "cd #{current_release} && RAILS_ENV=production bundle exec rake db:seed"
  end
end

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

## TODO soeren 09.03.12 warum kann ich auf uberspace kein mysql oder mysql2 Gem per "bundle install" installieren
## TODO soeren 09.03.12  deshalb aktuell kein bundle install
#namespace :deploy do
#  desc "bundle install --deployment --without development test"
#  task :bundle_install, :roles => [:web] do
#    run "cd #{release_path} && bundle install --deployment --without development test"
#  end
#end
#after "deploy:finalize_update", "deploy:bundle_install"

# FIXME soeren 07.03.12 warum klappt das nicht ???
#namespace :deploy do
#  desc 'Precompiling Assets'
#  task :precompile_assets, :roles => :app do
#    run "cd #{release_path} && RAILS_ENV=production bundle exec rake assets:precompile"
#  end
#  # Generate all the stylesheets manually (from their Sass templates) before each restart.
#  after 'deploy:update_code', 'deploy:precompile_assets'
#end





