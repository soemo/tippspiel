Airbrake.configure do |config|
  config.api_key = {:project => 'tippspiel',                     # the identifier you specified for your project in Redmine
                    :tracker => 'Fehler',                        # the name of your Tracker of choice in Redmine
                    :api_key => 'NxKSdL4VeOywsFmr2EeY',          # the key you generated before in Redmine (NOT YOUR HOPTOAD API KEY!)
                    :category => '',                             # the name of a ticket category (optional.)
                    :assigned_to => 'soemo',                     # the login of a user the ticket should get assigned to by default (optional.)
                    :priority => 5,                              # the default priority (use a number, not a name. optional.)
                    :environment => "#{ERROR_NOTIFICATION_CUSTOM_STAGE_NAME}", # application environment, gets prepended to the issue's subject and is stored as a custom issue field. useful to distinguish errors on a test system from those on the production system (optional).
                    :repository_root => ''                       # this optional argument overrides the project wide repository root setting (see below).
  }.to_yaml
  config.host = 'soemo.plan.io'                                  # the hostname your Redmine runs at
  config.port = 443                                              # the port your Redmine runs at
  config.secure = true                                           # sends data to your server via SSL (optional.)

  # https://github.com/airbrake/airbrake/wiki/Customizing-your-airbrake.rb

  # Aktivieren, wenn man mal lokal Fehler an den Tracker schicken will (eigentlich nur zum intialen Einrichten benoetigt)
  #config.development_environments = []
end
