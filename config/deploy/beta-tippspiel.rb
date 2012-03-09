role :app, "beta-tippspiel.soemo.org"
role :web, "beta-tippspiel.soemo.org"
role :db,  "beta-tippspiel.soemo.org", :primary => true

set :user, "soemo"
set :password, nil  # wird auf der Konsole angegeben
set :application, "beta-tippspiel.soemo.org"
set :deploy_to, "/var/www/virtual/#{user}/#{application}"

set :customizing_dir, "beta-em2012"

# aktuell nutzt ich rvm - ruby-1.8.7-p358

#set :default_environment, {
#  'PATH' => "$HOME/.gem/ruby/1.8/bin:/package/host/localhost/ruby-1.8.7/bin/:$PATH:"
#}
set :default_environment, {
  'PATH' => "/home/soemo/.rvm/gems/ruby-1.8.7-p358/bin:$HOME/.rvm/bin::$PATH",
  'RUBY_VERSION' => 'ruby 1.8.7',
  'GEM_HOME'     => '/home/soemo/.rvm/gems/ruby-1.8.7-p358',
  'GEM_PATH'     => '/home/soemo/.rvm/gems/ruby-1.8.7-p358',
 # 'BUNDLE_PATH'  => '/home/soemo/websites/beta-tippspiel.soemo.org/shared/bundle/ruby/1.8'
}
set :rake, "bundle exec rake" # TODO soeren frage ob ich das noch brauche