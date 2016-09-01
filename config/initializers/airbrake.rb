Airbrake.configure do |config|
  config.api_key = {project: ENV['AIRBRAKE_PROJECT'],         # the identifier you specified for your project in Redmine
                    tracker: ENV['AIRBRAKE_TRACKER'],         # the name of your Tracker of choice in Redmine
                    api_key: ENV['AIRBRAKE_API_KEY'],         # the key you generated before in Redmine (NOT YOUR HOPTOAD API KEY!)
                    category: '',                             # the name of a ticket category (optional.)
                    assigned_to: ENV['AIRBRAKE_ASSIGNED_TO'], # the login of a user the ticket should get assigned to by default (optional.)
                    priority: ENV['AIRBRAKE_PRIORITY'],       # the default priority (use a number, not a name. optional.)
                    environment: ENV['AIRBRAKE_ERROR_NOTIFICATION_CUSTOM_STAGE_NAME'], # application environment, gets prepended to the issue's subject and is stored as a custom issue field. useful to distinguish errors on a test system from those on the production system (optional).
                    repository_root: ''                       # this optional argument overrides the project wide repository root setting (see below).
  }.to_yaml
  config.host = ENV['AIRBRAKE_HOST']                          # the hostname your Redmine runs at
  config.port = ENV['AIRBRAKE_PORT']                          # the port your Redmine runs at
  config.secure = true                                        # sends data to your server via SSL (optional.)
end
