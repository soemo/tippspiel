namespace :deploy do

  desc 'Set version and build date in version.rb on the remote server.'
  task :set_build_date do
    on roles(:web) do
      within release_path do
        # APP_VERSION is written to $GITHUB_ENV by the CI workflow and inherited by the
        # `bundle exec cap` process on the runner. SSHKit's `with` forwards it as an
        # environment variable to the remote shell, where the Rakefile reads it via
        # ENV.fetch('APP_VERSION', placeholder_version).
        with app_version: ENV['APP_VERSION'] do
          execute :rake, 'tippspiel:set_version'
        end
      end
    end
  end
  after 'deploy:updated', 'deploy:set_build_date'

  desc 'Install/update the whenever crontab on the remote server.'
  task :update_crontab do
    on roles(:web) do
      # Run from current_path (the stable symlink) so cron entries never
      # reference a timestamped release directory that Capistrano will later
      # prune. Using release_path would cause cron jobs to fail once
      # keep_releases cleans up that directory.
      within current_path do
        with rails_env: fetch(:rails_env) do
          begin
            # --identifier scopes the crontab block to this app so multiple apps
            # on the same Uberspace account don't overwrite each other's entries.
            execute :bundle, :exec, :whenever,
                    '--update-crontab',
                    '--set', "environment=#{fetch(:rails_env)}",
                    '--identifier', fetch(:application)
          rescue SSHKit::Command::Failed => e
            # A crontab update failure must not abort the deploy — the new
            # release is already live and serving traffic. Log a warning so
            # the operator knows to re-run manually if needed.
            warn "[WARN] deploy:update_crontab failed (#{e.message}). " \
                 "Run 'bundle exec whenever --update-crontab' manually on the server."
          end
        end
      end
    end
  end
  # Hook into deploy:finished so the app is fully live before we attempt
  # the crontab update. Failure is rescued above and will not abort the deploy.
  after 'deploy:finished', 'deploy:update_crontab'

end

namespace :db do
  desc 'run db:seed'
  task :run_seed do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          puts capture(:rake, 'db:seed')
        end
      end
    end
  end
end
