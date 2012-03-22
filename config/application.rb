require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

require File.join(File.dirname(__FILE__), 'version')

module Tippspiel
  class Application < Rails::Application
    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # http://guides.rubyonrails.org/asset_pipeline.html
    # The default matcher for compiling files includes application.js, application.css and all non-JS/CSS files
    # (i.e., .coffee and .scss files are not automatically included as they compile to JS/CSS)
    config.assets.precompile += %w[active_admin.css active_admin.js]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Berlin'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = %w(jquery-1.5.1.min.js rails_jq.js)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.generators do |g|
      g.template_engine :haml
      g.test_framework  :rspec
    end

    config.middleware.use(ExceptionNotifier,
                          :email_prefix => "[Tippspiel Application Error] ",
                          :sender_address => %{tippspiel@soemo.org},
                          :exception_recipients => %w{tippspiel@soemo.org})

    config.after_initialize do |app|
      # 404 catch all route, hier definiert, damit sie immer die letzte Route ist

      app.routes.append{ match '*a', :to => 'application#rescue_404' } unless config.consider_all_requests_local
    end
  end
end
