require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require File.join(File.dirname(__FILE__), 'version')

module Tippspiel
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.autoloader = :classic # activate with rails 7 the new :zeitwerk

    # config.eager_load_paths << Rails.root.join("extras")

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns/{**/}"]
    config.autoload_paths += Dir["#{config.root}/app/models/{**/}"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns/{**/}"]
    config.autoload_paths += Dir["#{config.root}/app/presenters/{**/}"]
    config.autoload_paths += Dir["#{config.root}/app/services/{**/}"]
    config.autoload_paths += Dir["#{config.root}/app/serializers/{**/}"]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Berlin'

    # Wirft deprecation Warnung..., wenn nicht gesetzt;
    # http://stackoverflow.com/questions/20361428/rails-i18n-validation-deprecation-warning
    I18n.enforce_available_locales = false # altes Verhalten eingestellt

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    config.generators do |g|
      g.template_engine :haml
      g.test_framework  :rspec, :fixture => true
      g.fixture_replacement :factory_bot, :dir=> 'spec/factories'
    end

  end
end
