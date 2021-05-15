source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.6'
ruby '2.7.2'

gem 'bootsnap', require: false
gem 'mysql2', '= 0.5.3'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'cancancan', '= 2.3.0' #todo upgrade later
gem 'haml-rails'
gem 'devise', '= 4.7.1'
gem 'devise-encryptable'
gem 'acts_as_paranoid', '= 0.6.3' # todo upgrade >= 0.7.0 needs Rails 5.2+
gem 'sass-rails', '= 5.1.0' #todo upgrade later to sassc-rails
gem 'autoprefixer-rails' # Erweitert CSS um Vendor-Prefixe z.B: "-webkit-" oder "-moz-"
gem 'uglifier'
gem 'jquery-rails', '= 4.3.5'
gem 'foundation-rails', '= 6.2.4.0'
gem 'font-awesome-sass'
gem 'lograge'
gem 'virtus'
gem 'exception_notification'

# Emojimmy makes it possible to store emoji characters in ActiveRecord datastores
# that don’t support 4-Byte UTF-8 Unicode (utf8mb4) encoding
gem 'emojimmy'

group :development, :production do
  gem 'passenger', '= 6.0.8'
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
  gem 'rspec-rails', '= 3.7.2'
  gem 'capybara'     # rspec-rails braucht das um in den Views have_selector zu nutzen
  gem 'guard-rspec', require: false
  gem 'guard', '= 2.16.1', require: false
  gem 'fuubar'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'factory_bot_rails', '= 4.8.2'
  gem 'timecop'
  gem 'simplecov'
  gem 'rails-controller-testing'
end