namespace :deploy do

  desc 'set Versionnumber and Build-Date. Needs Rake Task APPLICATION:set_version (APPLICATION is the namespace)'
  task :set_version_and_date do
    on roles(:web) do
      within release_path do
        execute :rake, "tippspiel:set_version"
      end
    end
  end
  after 'deploy:updated', 'deploy:set_version_and_date'


  desc 'Customizing und Branding der reinen Ruby on Rails Anwendung'
  task :customizing do
    on roles(:web) do
      customizing_parent_dir = "#{release_path}/customizing"

      if customizing_parent_dir.size > 0
        customizing_path = "#{customizing_parent_dir}/#{fetch(:customizing_dir)}"

        info "copy files from #{customizing_path}"
        execute :cp, '-r -v', "#{customizing_path}/*", release_path

        info "delete orig customizing dir #{customizing_parent_dir}"
        execute :rm, '-rf', "#{customizing_parent_dir}"
      end
    end
  end
  before 'deploy:updated', 'deploy:customizing'

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
