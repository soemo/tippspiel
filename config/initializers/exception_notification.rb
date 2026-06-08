# frozen_string_literal: true

# https://github.com/smartinez87/exception_notification

BOT_PROBE_PATTERN = /
  (?:^|\/)\.env[\w.\-~%]*  |  # .env harvesting (including /.env%85 with invalid encoding)
  \.php\d*\z               |  # PHP file probes
  (?:^|\/)\.git\/          |  # git directory probes
  (?:^|\/)wp-              |  # WordPress paths
  (?:^|\/)cgi-bin             # CGI probes
/xi

Tippspiel::Application.config.middleware.use ExceptionNotification::Rack,
                                             ignore_if: lambda { |env, exception|
                                               exception.is_a?(ActionController::BadRequest) &&
                                                 env['PATH_INFO'].to_s.match?(BOT_PROBE_PATTERN)
                                             },
                                             email: {
                                               deliver_with: :deliver_now,
                                               email_prefix: ENV['EXCEPTION_NOTIFICATION_EMAIL_PREFIX'] || '[Tippspiel Application Error] ',
                                               sender_address: MAIL,
                                               exception_recipients: [ADMIN_EMAIL]
                                             }
