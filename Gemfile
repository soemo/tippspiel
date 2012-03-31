source 'http://rubygems.org'

gem 'rails', '3.2.2'

gem 'passenger',               '~> 3.0.11'
gem 'mysql',                   '~> 2.8.1'
gem 'cancan',                  '1.6.7'
gem 'haml-rails',              '0.3.4'
gem 'devise',                  '= 1.4.7'
gem 'rails3_acts_as_paranoid', '= 0.2.0'
gem 'sass',                    '3.1.15'
gem 'coffee-rails',            '~> 3.2.1'
gem 'jquery-rails',            '2.0.0'
gem 'execjs',                  '= 1.3.0'
gem 'therubyrhino',            '= 1.72.8'
gem 'activeadmin'
gem 'cancan',                  '= 1.6.7'
gem 'exception_notification',  '= 2.5.2'
gem 'bootstrap-sass',          '~> 2.0.2'
gem 'newrelic_rpm'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'uglifier',     '= 1.2.3'
end

# Development auch, damit Generatoren auch im DEV-Mode lauffaehig sind
group :development, :test do
  gem "capistrano",     "~> 2.11.2"
  gem "capistrano-ext", "~> 1.2.1"
  gem 'rspec-rails',    '= 2.6.1'
end

group :test do
  gem 'faker',              '= 0.9.5'
  gem 'factory_girl_rails', "= 1.4.0"
  gem 'webrat',             '= 0.7.3' #rspec-rails 2 braucht das um in den Views have_selector zu nutzen
end