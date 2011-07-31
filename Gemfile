source 'http://rubygems.org'

gem 'rails', '3.0.4'


gem 'pg',    '= 0.11.0'
gem 'mysql', '= 2.8.1'
gem 'haml',  '= 3.0.5'
gem 'devise', '= 1.1.7'
gem 'formtastic', '= 2.0.0.rc3'  # TODO soeren 11.07.11 wenn neue Version dann weg von RC version
gem 'simple_enum', '= 1.3.2'
gem 'vidibus-routing_error', "= 0.2.1"  # TODO soeren 20.07.11 mit Rails 3.1 soll das Problem mit ActionController::RoutingError geloest sein, dann kannn das gem weg

# Development auch, damit Generatoren auch im DEV-Mode lauffaehig sind
group :development, :test do
  gem 'mysql',      '= 2.8.1'
  gem 'rspec',      '=2.5.0'#, :lib => false
  gem 'rspec-rails','=2.5.0'#, :lib => false
end

group :test do
  gem 'i18n',  '=0.5'
  gem 'faker', '=0.9.5'
  gem 'factory_girl_rails', "= 1.1.rc1" # TODO soeren 11.07.11 wenn neue Version dann weg von RC version
  gem 'webrat', '=0.7.3' #rspec-rails 2 braucht das um in den Views have_selector zu nutzen
end