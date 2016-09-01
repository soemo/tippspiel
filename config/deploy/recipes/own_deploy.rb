namespace :deploy do

  desc 'set Versionnumber and Build-Date. Needs Rake Task APPLICATION:set_version (APPLICATION is the namespace)'
  task :set_version_and_date do
    on roles(:web) do
      within release_path do
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
