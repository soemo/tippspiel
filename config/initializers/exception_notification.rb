# https://github.com/smartinez87/exception_notification

Tippspiel::Application.config.middleware.use ExceptionNotification::Rack,
                                       email: {
                                         deliver_with: :deliver_now,
                                         email_prefix: ENV['EXCEPTION_NOTIFICATION_EMAIL_PREFIX'] || '[Tippspiel Application Error] ',
                                         sender_address: MAIL,
                                         exception_recipients: [ADMIN_EMAIL]
                                       }

