ActionMailer::Base.smtp_settings = {
        #:address => "smtp.soemo.org",
        :address => "smtprelaypool.ispgateway.de",
        :domain  => "soemo.org",
        #:port => 25,
        :port => 465,
        :user_name => "app_postfach@soemo.org",
        :password => "app_postfach",
        :authentication => :login,
        :enable_starttls_auto => true
}
