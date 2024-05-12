source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 6.1.7'
ruby '3.2.4'

#gem 'psych', '< 4' # https://stackoverflow.com/a/71192990

gem 'mysql2', '= 0.5.6'
gem 'dotenv-rails', require: 'dotenv/load'
gem 'cancancan'
gem 'haml', '6.3.0'
gem 'haml-rails'
gem 'devise'
gem 'devise-encryptable'
gem 'acts_as_paranoid'
gem 'sass-rails', '= 5.1.0' #todo upgrade later to sassc-rails
gem 'autoprefixer-rails' # Erweitert CSS um Vendor-Prefixe z.B: "-webkit-" oder "-moz-"
gem 'uglifier'
gem 'jquery-rails', '= 4.6.0'
gem 'foundation-rails', '= 6.2.4.0'
gem 'font-awesome-sass', '= 5.15.1'
gem 'lograge'
gem 'virtus'
gem 'exception_notification'

# Emojimmy makes it possible to store emoji characters in ActiveRecord datastores
# that don’t support 4-Byte UTF-8 Unicode (utf8mb4) encoding
gem 'emojimmy'

group :development, :production do
  gem 'passenger', '6.0.20'
end

group :development do
  gem 'rack-livereload'
  gem 'letter_opener_web'
  gem 'rack-mini-profiler'
end

# Development auch, damit Generatoren auch im DEV-Mode lauffaehig sind
group :development, :test do
  gem 'capistrano-rails'
  gem 'capistrano-uberspace', git: 'https://github.com/soemo/capistrano-uberspace.git', branch: 'master'
  gem 'capistrano-maintenance', require: false
  gem 'ed25519', '>= 1.2', '< 2.0'
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'capybara'     # rspec-rails braucht das um in den Views have_selector zu nutzen
  gem 'webrick'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'factory_bot_rails'
  gem 'timecop'
  gem 'simplecov'
  gem 'rails-controller-testing'
end