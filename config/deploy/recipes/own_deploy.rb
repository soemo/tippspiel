namespace :deploy do

  desc 'set Build-Date in version.rb. The version itself is already resolved by the CI workflow before deploy.'
  task :set_version_and_date do
    on roles(:web) do
      within release_path do
        # APP_VERSION is intentionally not passed here – the ###PLACEHOLDER_VERSION### was
        # already replaced with the real version (from git tag / release draft) by the
        # CI workflow via `sed` before Capistrano uploaded the release.
        # This call only substitutes ###PLACEHOLDER_BUILD_DATE### with today's date.
        execute :rake, 'tippspiel:set_version'
      end
    end
  end
  after 'deploy:updated', 'deploy:set_version_and_date'

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
