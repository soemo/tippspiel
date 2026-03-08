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
