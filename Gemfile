source 'http://rubygems.org'

gem 'rails',                   '~> 3.2.16'
ruby '1.9.3'

gem 'mysql2',                  '~> 0.3.11'
gem 'cancan',                  '~> 1.6.10'
gem 'haml-rails',              '~> 0.4'
gem 'devise',                  '~> 2.2.4'
gem 'rails3_acts_as_paranoid', '~> 0.2.5'
gem 'sass',                    '~> 3.2.5'
gem 'jquery-rails',            '~> 3.0.4'  # jQuery 1.10.2
gem 'execjs',                  '~> 1.4.0'
gem 'therubyracer',            '~> 0.11.2', :platforms=>:ruby
gem 'rails_admin',             '~> 0.4.9'
gem 'bootstrap-sass',          '~> 2.3.1.0'
gem 'newrelic_rpm',            '~> 3.6.2.96'
gem 'feed-normalizer',         '~> 1.5.2'

gem 'lograge',                 '~> 0.2.2'

# Wird genutzt um per https://github.com/yeah/redmine_hoptoad_server die ErrorNotifications ins Redmine zu bekommen
gem 'airbrake',                '~> 3.1.12'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.2'
  gem 'sass-rails',   '~> 3.2.6'
  gem 'uglifier',     '~> 1.3.0'
end

group :development, :production do
  gem 'passenger',  '~> 4.0.33'

end

group :development do
  gem 'magic_encoding',    '~> 0.0.2'
  gem 'letter_opener',     '~> 1.1.1'
  gem 'better_errors',     '~> 1.1.0'    # Provides a better error page for Rails and other Rack apps
  gem 'binding_of_caller', '~> 0.7.2'    # Retrieve the binding of a method's caller. Can also retrieve bindings even further up the stack.
end

# Development auch, damit Generatoren auch im DEV-Mode lauffaehig sind
group :development, :test do
  gem 'rails_best_practices', '~> 1.13.5' # a code metric tool for rails projects
  gem 'uberspacify', :git => 'https://github.com/soemo/uberspacify.git' # soeren 19.01.13 jans wieder nutzen, wenn er meine Anpassungen bei ihm drin hat
  gem 'capistrano',           '~> 2.15.4'
  gem 'capistrano-ext',       '~> 1.2.1'
  gem 'rvm-capistrano',       '~> 1.3.0'
  gem 'rspec-rails',          '~> 2.13.2'
  gem 'thin',                 '~> 1.5.1'     # lokaler Dev Server
  gem 'pry',                  '~> 0.9.12.2'   # binding.pry -> debugging
end

group :test do
  gem 'webmock',            '~> 1.11.0'
  gem 'faker',              '~> 1.1.2'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'webrat',             '~> 0.7.3' #rspec-rails 2 braucht das um in den Views have_selector zu nutzen
end