# -*- encoding : utf-8 -*-
require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require File.join(File.dirname(__FILE__), 'version')

module Tippspiel
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths << Rails.root.join('lib')

    # Enable the asset pipeline
    config.assets.enabled = true

    # FIXME soeren 10.09.2014 kommt weg Rails 4.1
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # FIXME soeren 10.09.2014 kommt weg Rails 4.1
    # http://guides.rubyonrails.org/asset_pipeline.html
    # The default matcher for compiling files includes application.js, application.css and all non-JS/CSS files
    # (i.e., .coffee and .scss files are not automatically included as they compile to JS/CSS)
    config.assets.precompile += %w[]



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
      g.fixture_replacement :factory_girl, :dir=> 'spec/factories'
    end

    config.after_initialize do |app|
      # 404 catch all route, hier definiert, damit sie immer die letzte Route ist

      app.routes.append{ get '*a', :to => 'application#rescue_404' } unless config.consider_all_requests_local
    end
  end
end
