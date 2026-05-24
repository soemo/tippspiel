# frozen_string_literal: true

# AppSignal Ruby gem configuration
# Visit our documentation for a list of all available configuration options.
# https://docs.appsignal.com/ruby/configuration/options.html
Appsignal.configure do |config|
  config.activate_if_environment('development', 'production')
  config.name = 'Tippspiel'
  config.push_api_key = ENV.fetch('APPSIGNAL_PUSH_API_KEY', nil)

  # Use shared log directory managed by Capistrano
  config.log_path = File.expand_path('../log', __dir__)

  # Explicit working dir (AppSignal agent socket/pid files)
  config.working_directory_path = '/tmp/appsignal'

  # Ignore health check endpoint to avoid consuming plan request quota
  # (AppSignal uptime monitoring pings this every minute from 4 regions)
  config.ignore_actions << 'HealthChecksController#show'

  # Configure errors that should not be recorded by AppSignal.
  # For more information see our docs:
  # https://docs.appsignal.com/ruby/configuration/ignore-errors.html
  # config.ignore_errors << "MyCustomError"
end
