source 'https://rubygems.org'

gem 'rails',                   '4.1.6'
ruby '1.9.3'

gem 'mysql2',                  '~> 0.3.16'
gem 'cancancan',               '~> 1.9.2'      # Authorization System
gem 'haml-rails',              '~> 0.5.3'      # haml-Generatoren
gem 'devise',                  '~> 3.3.0'      # Authentifizierungssystem
gem 'devise-encryptable',      '~> 0.2.0'      # Encryption solution for salted-encryptors on Devise

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# Wird aktuell von uns nicht benutzt gem 'turbolinks'

gem 'paranoia',                '~> 2.0.2'      # acts_as_paranoid fuer Rails4
gem 'sass-rails',              '~> 4.0.3'
gem 'coffee-rails',            '~> 4.0.1'
gem 'uglifier',                '~> 2.5.3'
gem 'jquery-rails',            '~> 3.1.2'      # mit jQuery 1.11.1 und jquery-ujs 1.0.1
gem 'execjs',                  '~> 2.2.1'      # ExecJS lets you run JavaScript code from Ruby.
gem 'therubyracer',            '~> 0.11.2', :platforms=>:ruby  # # FIXME soeren 10.09.2014  neuere Version auf uberspace testen
gem 'rails_admin',             '~> 0.6.3'      # Interface zur Daten-Administration
gem 'bootstrap-sass',          '~> 2.3.1.3'    # FIXME soeren 10.09.2014 Umstieg auf Foundation
gem 'newrelic_rpm',            '~> 3.9.4.245'  # performance management system, developed by New Relic
gem 'feed-normalizer',         '~> 1.5.2'      # wrapper for Atom and RSS parsers
gem 'cells',                   '~> 3.11.2'     # Cells are view components for Rails.
gem 'lograge',                 '~> 0.3.0'

# Wird genutzt um per https://github.com/yeah/redmine_hoptoad_server die ErrorNotifications ins Redmine zu bekommen
gem 'airbrake',                '~> 4.1.0' # FIXME soeren 10.09.2014 #86 testen  https://github.com/airbrake/airbrake/blob/master/CHANGELOG

# TODO soeren 22.07.2014 #4642 Rails 4.0 has removed attr_accessible and attr_protected feature in favor of Strong Parameters. You can use the Protected Attributes gem for a smooth upgrade path.
gem 'protected_attributes',     '~> 1.0.8'

# gem 'jbuilder', '~> 2.0' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

# https://github.com/tzinfo/tzinfo/wiki/Resolving-TZInfo::DataSourceNotFound-Errors
gem 'tzinfo-data', platforms: [:mingw, :mswin]

group :development, :production do
  gem 'passenger', '~> 4.0.33' # '~> 4.0.50'  # a modern web server and application server for Ruby
  # FIXME soeren 18.04.14 update was muss ich da bei uberspace noch machen
end

group :development do
  gem 'better_errors',     '~> 1.1.0'    # Provides a better error page for Rails and other Rack apps
  gem 'binding_of_caller', '~> 0.7.2'    # Retrieve the binding of a method's caller. Can also retrieve bindings even further up the stack.
end

# Development auch, damit Generatoren auch im DEV-Mode lauffaehig sind
group :development, :test do
  gem 'uberspacify', :git => 'https://github.com/soemo/uberspacify.git' # soeren 19.01.13 jans wieder nutzen, wenn er meine Anpassungen drin hat
  # FIXME soeren 17.09.2014 gem 'capistrano-rails',          '~> 1.1.2'  # Rails specific Capistrano tasks
  gem 'capistrano',                '~> 2.15.4' # FIXME soeren 10.09.2014 neue Version testen
  gem 'capistrano-ext',            '~> 1.2.1'
  gem 'rvm-capistrano',            '~> 1.3.0'  # FIXME soeren 10.09.2014 neue Version testen

  gem 'rspec-rails',               '~> 3.1.0'
  gem 'rspec-collection_matchers', '~> 1.0.0'    # Collection cardinality matchers, extracted from rspec-expectations
  gem 'thin',                      '~> 1.6.2'    # lokaler Dev Server
  # http://stackoverflow.com/a/14328137
  gem 'capybara',                  '~> 2.4.1'    # rspec-rails braucht das um in den Views have_selector zu nutzen
end

group :test do
  gem 'webmock',            '~> 1.18.0'
  gem 'faker',              '~> 1.1.2'  # FIXME soeren 10.09.2014 nutze ich das ueberhaupt noch
  gem 'factory_girl_rails', '~> 4.4.1'

  gem 'rspec-cells',        '~> 0.2.2'
  gem 'simplecov',          '~> 0.9.0'  # Code coverage for Ruby 1.9+
end