source 'https://rubygems.org'

gem 'rails', '~> 4.2.0'
ruby '2.1.5'

gem 'mysql2',                  '~> 0.3.17'
gem 'cancancan',               '~> 1.9.2'      # Authorization System    # FIXME soeren 30.12.2014 pundit???
gem 'haml-rails',              '~> 0.5.3'      # haml-Generatoren
gem 'devise',                  '~> 3.4.1'      # Authentifizierungssystem
gem 'devise-encryptable',      '~> 0.2.0'      # Encryption solution for salted-encryptors on Devise


# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# Wird aktuell von uns nicht benutzt gem 'turbolinks'

gem 'paranoia',                '~> 2.0.2'      # acts_as_paranoid fuer Rails4
gem 'sass-rails',              '~> 4.0.3'
gem 'coffee-rails',            '~> 4.0.1'
gem 'uglifier',                '~> 2.5.3'
gem 'jquery-rails',            '~> 3.1.2'      # mit jQuery 1.11.1 und jquery-ujs 1.0.1
gem 'execjs',                  '~> 2.2.1'      # ExecJS lets you run JavaScript code from Ruby.
gem 'therubyracer',            '~> 0.11.2', :platforms=>:ruby
gem 'rails_admin',             '~> 0.6.6'      # Interface zur Daten-Administration
gem 'bootstrap-sass',          '~> 2.3.1.3'    # FIXME soeren 10.09.2014 Upgrade auf Version 3
gem 'newrelic_rpm',            '~> 3.9.9.275'  # performance management system, developed by New Relic
gem 'feed-normalizer',         '~> 1.5.2'      # wrapper for Atom and RSS parsers
gem 'cells',                   '~> 3.11.3'     # Cells are view components for Rails.
gem 'lograge',                 '~> 0.3.0'

# Wird genutzt um per https://github.com/yeah/redmine_hoptoad_server die ErrorNotifications ins Redmine zu bekommen
gem 'airbrake',                '~> 4.1.0' # FIXME soeren 10.09.2014 #86 testen  https://github.com/airbrake/airbrake/blob/master/CHANGELOG

gem 'virtus',                  '~> 1.0.3'     # Attributes on Steroids for Plain Old Ruby Objects

# gem 'jbuilder', '~> 2.0' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

# https://github.com/tzinfo/tzinfo/wiki/Resolving-TZInfo::DataSourceNotFound-Errors
gem 'tzinfo-data', platforms: [:mingw, :mswin]

group :development, :production do
  gem 'passenger', '~> 4.0.58' #  # a modern web server and application server for Ruby
  # FIXME soeren 18.04.14 update was muss ich da bei uberspace noch machen - per svc den daemon neu durchstarten
end

group :development do
  gem 'better_errors',     '~> 2.1.0'    # Provides a better error page for Rails and other Rack apps
  gem 'binding_of_caller', '~> 0.7.2'    # Retrieve the binding of a method's caller. Can also retrieve bindings even further up the stack.

  gem 'web-console',       '~> 2.0.0'    # A set of debugging tools for your Rails application.

  gem 'spring', '~> 1.2.0'
  gem 'spring-commands-rspec', '~>1.0.2'
  gem 'rack-livereload'
  gem 'guard-livereload', require: false
end

# Development auch, damit Generatoren auch im DEV-Mode lauffaehig sind
group :development, :test do
  gem 'uberspacify', :git => 'https://github.com/soemo/uberspacify.git'

  gem 'quiet_assets',              '~> 1.1.0'
  gem 'capistrano',                '~> 2.15.4'
  gem 'capistrano-ext',            '~> 1.2.1'
  gem 'rvm-capistrano',            '~> 1.3.0'

  gem 'rspec-rails',               '~> 3.1.0'
  # FIXME soeren 31.12.2014 entfernen rspec-collection_matchers
  gem 'rspec-collection_matchers', '~> 1.0.0'    # Collection cardinality matchers, extracted from rspec-expectations
  # http://stackoverflow.com/a/14328137
  gem 'capybara',                  '~> 2.4.4'    # rspec-rails braucht das um in den Views have_selector zu nutzen

  gem 'guard-rspec', require: false
end

group :test do
  gem 'webmock',            '~> 1.20.4'
  gem 'factory_girl_rails', '~> 4.5.0'

  gem 'rspec-cells',        '~> 0.2.2'
  gem 'simplecov',          '~> 0.9.1'  # Code coverage for Ruby 1.9+
end