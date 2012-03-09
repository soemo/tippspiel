role :app, "tippspiel.soemo.org"
role :web, "tippspiel.soemo.org"
role :db,  "tippspiel.soemo.org", :primary => true

set :user, "soemo"
set :password, nil  # wird auf der Konsole angegeben
set :application, "tippspiel.soemo.org"
set :deploy_to, "/var/www/virtual/#{user}/#{application}"

set :customizing_dir, "em2012"

# aktuell nutzt ich rvm - ruby-1.8.7-p358
set :default_environment, {
  'PATH' => "$HOME/.rvm/gems/ruby-1.8.7-p358/bin:$HOME/.rvm/bin::$PATH",
  'RUBY_VERSION' => 'ruby 1.8.7',
  'GEM_HOME'     => '$HOME/.rvm/gems/ruby-1.8.7-p358',
  'GEM_PATH'     => '$HOME/.rvm/gems/ruby-1.8.7-p358',
}
set :rake, "bundle exec rake"