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
      within release_path do
        with rails_env: fetch(:rails_env) do
          # --identifier scopes the crontab block to this app so multiple apps
          # on the same Uberspace account don't overwrite each other's entries.
          execute :bundle, :exec, :whenever,
                  '--update-crontab',
                  '--set', "environment=#{fetch(:rails_env)}",
                  '--identifier', fetch(:application)
        end
      end
    end
  end
  after 'deploy:updated', 'deploy:update_crontab'

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
