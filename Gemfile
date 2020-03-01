source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.5'
ruby '2.5.7'

gem 'mysql2'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'cancancan'
gem 'haml-rails'
gem 'devise'
gem 'devise-encryptable'
gem 'paranoia'
gem 'sass-rails'
gem 'autoprefixer-rails' # Erweitert CSS um Vendor-Prefixe z.B: "-webkit-" oder "-moz-"
gem 'uglifier'
gem 'jquery-rails'
gem 'foundation-rails'
gem 'font-awesome-sass'
gem 'lograge'
gem 'virtus'
gem 'exception_notification'

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
  gem 'capistrano-uberspace', git: 'https://github.com/soemo/capistrano-uberspace.git', branch: 'master'
  gem 'capistrano-maintenance', require: false
  gem 'rspec-rails'
  gem 'capybara'     # rspec-rails braucht das um in den Views have_selector zu nutzen
  gem 'guard-rspec', require: false
  gem 'fuubar'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'factory_bot_rails'
  gem 'timecop'
  gem 'simplecov'
  gem 'codeclimate-test-reporter', require: nil
  gem 'rails-controller-testing'
end