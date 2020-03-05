# a name for your app, will be used for your gemset,
# databases, directories, etc.
set :application, 'beta-tippspiel.soemo.org'

set :branch, 'master'

# By default, your app will be available in the root of your Uberspace. If you
# have your own domain set up, you can configure it here
set :domain, 'beta-tippspiel.soemo.org'

set :database_name_suffix, "beta_#{fetch(:cap_tournament_name).downcase.gsub(' ', '_')}"

# You have to set where to store the code
# the default /var/www/my_app_name won't work on uberspace
set :deploy_to, "/var/www/virtual/#{fetch(:user)}/#{fetch(:application)}"

# By default, uberspacify will generate a random port number for Passenger to
# listen on. This is fine, since only Apache will use it. Your app will always
# be available on port 80 and 443 from the outside. However, if you'd like to
# set this yourself, go ahead.
set :passenger_port, 26100
