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



#test task
task :uname do
  run "uname -a"
end

## # # FIXME soeren 05.03.12 abgleichen was ich brauche
### ## ## ## ## ## ## ## ## ## ## ## ## ##
### Dont Modify following Tasks!
###
#namespace :deploy do
#
#  desc "Restarting mod_rails with restart.txt"
#  task :restart, :roles => :app, :except => { :no_release => true } do
#    run "touch #{current_path}/tmp/restart.txt"
#  end
#
#
#  desc "Overwriten Symbolic link Task, Please dont change this"
#  task :symlink, :roles => :app do
#    on_rollback do
#      if previous_release
#      run "rm #{current_path}; ln -s ./releases/#{releases[-2]} #{current_path}"
#      else
#        logger.important "no previous release to rollback to, rollback of symlink skipped"
#      end
#    end
#    run "cd #{deploy_to} && rm -f #{current_path}                      && ln -s ./releases/#{release_name} #{current_path}"
#    run "cd #{deploy_to} && rm -f #{current_path}/config/database.yml  && ln -s ../../../shared/config/database.yml #{current_path}/config/"
#    run "cd #{deploy_to} && rm -f #{current_path}/public/.htaccess     && ln -s ../../../shared/config/.htaccess #{current_path}/public/.htaccess"
#    run "cd #{deploy_to} && rm -f ./current/log                        && ln -s ../../shared/log #{current_path}/"
#    run "cd #{deploy_to} && rm -f ./current/pids                       && ln -s ../../shared/pids #{current_path}/"
#    run "cd #{deploy_to} && rm -f ./current/public/system              && ln -s ../../../shared/system #{current_path}/public/"
#  end
#
#  after "deploy:update_code" do
#    # do not use bunlder on railshoster as it does not seem to play nice with browsercms... :-(
#    run "cd #{deploy_to} && rm -f #{release_path}/Gemfile"
#    run "cd #{deploy_to} && rm -f #{release_path}/Gemfile.lock"
#  end
#
#  after "deploy:rollback" do
#    if previous_release
#      run "rm #{current_path}; ln -s ./releases/#{releases[-2]} #{current_path}"
#    else
#      abort "could not rollback the code because there is no prior release"
#    end
#  end
#
#end
#
#
#namespace :bundle do
#  desc "Bundle install"
#  task :install, :roles => :app do
#    run "cd #{current_path} && bundle check || bundle install --path=/home/#{user}/.bundle --without=test"
#  end
#end
#
#
#
#namespace :rollback do
#
#  desc "overwrite rollback because of relative symlink paths"
#  task :revision, :except => { :no_release => true } do
#    if previous_release
#      run "rm -f #{current_path}; ln -s ./releases/#{releases[-2]} #{current_path}"
#    else
#      abort "could not rollback the code because there is no prior release"
#    end
#  end
#
#end
#
#namespace :sitemap do
#  task :verify_signatories, :roles => :app do
#    rake = fetch(:rake, "rake")
#    rails_env = fetch(:rails_env, "production")
#    run "cd \#{current_path}; \#{rake} RAILS_ENV=\#{rails_env} sitemap:verify_signatories"
#  end
#end
#after "deploy:finalize_update", "sitemap:verify_signatories"
