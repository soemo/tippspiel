source 'https://rubygems.org'

gem 'rails', '= 4.2.5.2'
ruby '2.2.4'

gem 'mysql2',                  '~> 0.3.18'
gem 'cancancan',               '~> 1.13.1'      # Authorization System    # FIXME soeren 30.12.2014 pundit???
gem 'haml-rails',              '~> 0.5.3'      # haml-Generatoren
gem 'devise',                  '~> 3.4.1'      # Authentifizierungssystem
gem 'devise-encryptable',      '~> 0.2.0'      # Encryption solution for salted-encryptors on Devise


# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# Wird aktuell von uns nicht benutzt gem 'turbolinks'

gem 'paranoia',                '~> 2.0.2'      # acts_as_paranoid fuer Rails4
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
# FIXME soeren update
gem 'jquery-rails',            '~> 3.1.2'      # mit jQuery 1.11.1 und jquery-ujs 1.0.1
gem 'therubyracer',            '~> 0.11.2', :platforms=>:ruby
gem 'rails_admin'                              # Interface zur Daten-Administration
gem 'foundation-rails'
gem 'font-awesome-sass'
gem 'newrelic_rpm'
gem 'feedjira',                '~> 1.6.0'      # RSS parsers
gem 'cells',                   '~> 3.11.3'     # Cells are view components for Rails.
gem 'lograge',                 '~> 0.3.1'
# Wird genutzt um per https://github.com/yeah/redmine_hoptoad_server die ErrorNotifications ins Redmine zu bekommen
gem 'airbrake',                '~> 4.1.0'

gem 'virtus',                  '~> 1.0.5'     # Attributes on Steroids for Plain Old Ruby Objects

group :development, :production do
  #gem 'passenger', '= 4.0.57'
  gem 'passenger'
end

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'rack-livereload'
  gem 'guard-livereload', require: false
end

# Development auch, damit Generatoren auch im DEV-Mode lauffaehig sind
group :development, :test do
  gem 'capistrano-rails'
  gem 'capistrano-uberspace', github: 'soemo/capistrano-uberspace', branch: 'master'
  gem 'quiet_assets',              '~> 1.1.0'
  gem 'rspec-rails',               '~> 3.2.1'
  gem 'capybara',                  '~> 2.4.4'    # rspec-rails braucht das um in den Views have_selector zu nutzen

  gem 'guard-rspec', require: false
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'webmock',            '~> 1.20.4'
  gem 'factory_girl_rails', '~> 4.5.0'

  gem 'timecop'

  gem 'rspec-cells',        '~> 0.2.2'
  gem 'simplecov'
end