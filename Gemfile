# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 6.1.7'
ruby '3.2.11'

# gem 'psych', '< 4' # https://stackoverflow.com/a/71192990

gem 'acts_as_paranoid'
gem 'autoprefixer-rails' # Erweitert CSS um Vendor-Prefixe z.B: "-webkit-" oder "-moz-"
gem 'cancancan'
gem 'devise'
gem 'devise-encryptable'
gem 'dotenv-rails', require: 'dotenv/load'
gem 'exception_notification'
gem 'font-awesome-sass', '= 5.15.1'
gem 'foundation-rails', '= 6.2.4.0'
gem 'haml', '= 5.2.2'
gem 'haml-rails'
gem 'jquery-rails', '= 4.6.0'
gem 'lograge'
gem 'mysql2', '= 0.5.6'
gem 'sass-rails', '= 5.1.0' # TODO: upgrade later to sassc-rails
gem 'uglifier'
gem 'virtus'
gem 'whenever', require: false # cron schedule for result imports

group :development, :production do
  gem 'passenger', '6.0.20'
end

group :development do
  gem 'letter_opener_web'
  gem 'rack-livereload'
  gem 'rack-mini-profiler'

  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
end

# Development auch, damit Generatoren auch im DEV-Mode lauffaehig sind
group :development, :test do
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
  gem 'capistrano-maintenance', require: false
  gem 'capistrano-rails'
  gem 'capistrano-uberspace', git: 'https://github.com/soemo/capistrano-uberspace.git', branch: 'master'
  gem 'capybara' # rspec-rails braucht das um in den Views have_selector zu nutzen
  gem 'ed25519', '>= 1.2', '< 2.0'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'webrick'
end

group :test do
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', require: false
  gem 'simplecov'
  gem 'timecop'
end
