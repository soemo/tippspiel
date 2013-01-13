source 'http://rubygems.org'

gem 'rails', '3.2.11'

gem "mysql2",                  "~> 0.3.11"
gem "cancan",                  "~> 1.6.8"
gem "haml-rails",              "~> 0.3.5"
gem 'devise',                  '= 1.4.7' # TODO soeren 13.01.13 update #31
gem "rails3_acts_as_paranoid", "~> 0.2.5"
gem "sass",                    "~> 3.2.5"
gem "jquery-rails",            "~> 2.1.4"
gem "execjs",                  "~> 1.4.0"
gem "therubyracer",            "~> 0.11.2", :platforms=>:ruby
gem 'activeadmin'                          # TODO soeren 13.01.13 raus mit #15
gem "exception_notification",  "~> 3.0.0"
gem 'bootstrap-sass',          '~> 2.0.3'  # TODO soeren 13.01.13 update #32
gem "newrelic_rpm",            "~> 3.5.5.38"
gem "feed-normalizer",         "~> 1.5.2"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "coffee-rails", "~> 3.2.2"
  gem "sass-rails",   "~> 3.2.5"
  gem "uglifier",     "~> 1.3.0"
end

group :development, :production do
  gem "passenger",  "~> 3.0.19"
end

group :development do
  gem "letter_opener",  "~> 1.0.0"
  gem "magic_encoding", "~> 0.0.2"
end

# Development auch, damit Generatoren auch im DEV-Mode lauffaehig sind
group :development, :test do
  gem "capistrano",     "~> 2.14.1"
  gem "capistrano-ext", "~> 1.2.1"
  gem "rspec-rails",    "~> 2.12.2"

  gem "pry",            "~> 0.9.9.6"   #binding.pry -> debugging
end
             # Fixme soeren 13.01.13 die hier auch noch updaten
group :test do
  gem "webmock",            "~> 1.8.7"
  gem 'faker',              '= 0.9.5'
  gem 'factory_girl_rails', "= 1.4.0" # TODO soeren 12.01.13 update
  gem 'webrat',             '= 0.7.3' #rspec-rails 2 braucht das um in den Views have_selector zu nutzen
end