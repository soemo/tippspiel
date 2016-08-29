source 'https://rubygems.org'

gem 'rails', '= 4.2.7'
ruby '2.3.1'

gem 'mysql2'
gem 'cancancan'    # FIXME soeren 30.12.2014 pundit???
gem 'haml-rails'
gem 'devise',                  '~> 3.4.1'      # Authentifizierungssystem
gem 'devise-encryptable',      '~> 0.2.0'      # Encryption solution for salted-encryptors on Devise
gem 'paranoia'      # acts_as_paranoid fuer Rails4
gem 'sass-rails'
gem 'autoprefixer-rails' # Erweitert CSS um Vendor-Prefixe z.B: "-webkit-" oder "-moz-"
gem 'uglifier'
gem 'jquery-rails',            '~> 4.1.1'     # mit jQuery 1.12.1 /2.2.1 und jquery-ujs 1.2.1
gem 'foundation-rails'
gem 'font-awesome-sass'
gem 'newrelic_rpm'
gem 'lograge'
# Wird genutzt um per https://github.com/yeah/redmine_hoptoad_server die ErrorNotifications ins Redmine zu bekommen
gem 'airbrake',                '~> 4.1.0'
gem 'virtus',                  '~> 1.0.5'     # Attributes on Steroids for Plain Old Ruby Objects

# Emojimmy makes it possible to store emoji characters in ActiveRecord datastores
# that don’t support 4-Byte UTF-8 Unicode (utf8mb4) encoding
gem 'emojimmy'


group :development, :production do
  gem 'passenger'
end

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'rack-livereload'
  gem 'guard-livereload', require: false
  gem 'letter_opener_web'
  gem 'rack-mini-profiler'
end

# Development auch, damit Generatoren auch im DEV-Mode lauffaehig sind
group :development, :test do
  gem 'capistrano-rails'
  gem 'capistrano-uberspace', github: 'soemo/capistrano-uberspace', branch: 'master'
  gem 'quiet_assets'
  gem 'rspec-rails'
  gem 'capybara'     # rspec-rails braucht das um in den Views have_selector zu nutzen
  gem 'guard-rspec', require: false
  gem 'fuubar'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'factory_girl_rails'
  gem 'timecop'
  gem 'simplecov'
end