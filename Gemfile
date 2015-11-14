source 'https://rubygems.org'

gem 'rails', '~> 4.2.3'
ruby '2.2.3'

gem 'mysql2',                  '~> 0.3.18'
gem 'cancancan',               '~> 1.9.2'      # Authorization System    # FIXME soeren 30.12.2014 pundit???
gem 'haml-rails',              '~> 0.5.3'      # haml-Generatoren
gem 'devise',                  '~> 3.4.1'      # Authentifizierungssystem
gem 'devise-encryptable',      '~> 0.2.0'      # Encryption solution for salted-encryptors on Devise


# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# Wird aktuell von uns nicht benutzt gem 'turbolinks'

gem 'paranoia',                '~> 2.0.2'      # acts_as_paranoid fuer Rails4
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'jquery-rails',            '~> 3.1.2'      # mit jQuery 1.11.1 und jquery-ujs 1.0.1
gem 'execjs',                  '~> 2.2.1'      # ExecJS lets you run JavaScript code from Ruby.
gem 'therubyracer',            '~> 0.11.2', :platforms=>:ruby
gem 'rails_admin',             '~> 0.6.7'      # Interface zur Daten-Administration
gem 'foundation-rails'
gem 'font-awesome-sass'
gem 'newrelic_rpm'
gem 'feedjira',                '~> 1.6.0'      # RSS parsers
gem 'cells',                   '~> 3.11.3'     # Cells are view components for Rails.
gem 'lograge',                 '~> 0.3.1'

# Wird genutzt um per https://github.com/yeah/redmine_hoptoad_server die ErrorNotifications ins Redmine zu bekommen
gem 'airbrake',                '~> 4.1.0'

gem 'virtus',                  '~> 1.0.5'     # Attributes on Steroids for Plain Old Ruby Objects

# gem 'jbuilder', '~> 2.0' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

# https://github.com/tzinfo/tzinfo/wiki/Resolving-TZInfo::DataSourceNotFound-Errors
gem 'tzinfo-data', platforms: [:mingw, :mswin]

group :development, :production do
  gem 'passenger', '= 5.0.6'
end

group :development do
  gem 'better_errors',     '~> 2.1.0'    # Provides a better error page for Rails and other Rack apps
  gem 'binding_of_caller', '~> 0.7.2'    # Retrieve the binding of a method's caller. Can also retrieve bindings even further up the stack.

  gem 'web-console',       '~> 2.0.0'    # A set of debugging tools for your Rails application.

  gem 'spring', '~> 1.3.4'
  gem 'spring-commands-rspec', '~>1.0.4'
  gem 'rack-livereload'
  gem 'guard-livereload', require: false
end

# Development auch, damit Generatoren auch im DEV-Mode lauffaehig sind
group :development, :test do
  gem 'uberspacify', :git => 'https://github.com/soemo/uberspacify.git'

  gem 'quiet_assets',              '~> 1.1.0'
  gem 'capistrano',                '~> 2.15.4'
  gem 'capistrano-ext',            '~> 1.2.1'

  gem 'rspec-rails',               '~> 3.2.1'
  gem 'capybara',                  '~> 2.4.4'    # rspec-rails braucht das um in den Views have_selector zu nutzen

  gem 'guard-rspec', require: false
end

group :test do
  gem 'webmock',            '~> 1.20.4'
  gem 'factory_girl_rails', '~> 4.5.0'

  gem 'timecop'

  gem 'rspec-cells',        '~> 0.2.2'
  gem 'simplecov',          '~> 0.9.1'  # Code coverage for Ruby 1.9+
end