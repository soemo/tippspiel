source 'http://rubygems.org'

gem 'rails', '3.1.0'

gem 'haml-rails', '0.3.4'
gem 'devise', '= 1.4.7'
gem 'formtastic', '< 2.0.0'
gem 'simple_enum', '= 1.3.2'
gem 'rails3_acts_as_paranoid', '= 0.1.1'
gem 'sass', '3.1.7'
gem 'coffee-rails', '3.1.1'
gem 'jquery-rails', '1.0.12'
gem 'uglifier'
gem 'activeadmin'
gem 'sass-rails'
gem "meta_search", '>= 1.1.0.pre'

# Development auch, damit Generatoren auch im DEV-Mode lauffaehig sind
group :development, :test do
  gem 'mysql',      '= 2.8.1'
  gem 'rspec-rails','=2.6.1'
end

group :production do
 # gem 'therubyracer-heroku', '0.8.1.pre3'  ## FIXME soeren 20.11.11 was ist damit brauche ich das
  gem 'pg'
end

group :test do
  gem 'faker', '=0.9.5'
  gem 'factory_girl_rails', "= 1.2"
  gem 'webrat', '=0.7.3' #rspec-rails 2 braucht das um in den Views have_selector zu nutzen
end