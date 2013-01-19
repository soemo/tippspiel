# -*- encoding : utf-8 -*-

# By default, your app will be available in the root of your Uberspace. If you
# have your own domain set up, you can configure it here
set :domain, "tippspiel.soemo.org"

set :database_name_suffix, "em2012" # FIXME soeren 19.01.13 jahr konfiguroerbar machen

# a name for your app, will be used for your gemset,
# databases, directories, etc.
set :application, "tippspiel.soemo.org"
set :deploy_to, "/var/www/virtual/#{user}/#{application}"

# By default, uberspacify will generate a random port number for Passenger to
# listen on. This is fine, since only Apache will use it. Your app will always
# be available on port 80 and 443 from the outside. However, if you'd like to
# set this yourself, go ahead.
set :passenger_port, 26101

set :customizing_dir, "em2012"

# aktuell nutzt ich rvm - ruby-1.8.7-p358
#set :default_environment, {
#  'PATH' => "$HOME/.rvm/gems/ruby-1.8.7-p358/bin:$HOME/.rvm/bin:$PATH",
#  'RUBY_VERSION' => 'ruby 1.8.7',
#  'GEM_HOME'     => '$HOME/.rvm/gems/ruby-1.8.7-p358',
#  'GEM_PATH'     => '$HOME/.rvm/gems/ruby-1.8.7-p358',
#}
#set :rake, "bundle exec rake"
