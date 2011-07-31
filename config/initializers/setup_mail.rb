ActionMailer::Base.smtp_settings = {
        :address => "smtp.soemo.org",
        :domain  => "soemo.org",
        :port => 25,
        :user_name => "app_postfach@soemo.org",
        :password => "app_postfach",
        :authentication => :login,
        :enable_starttls_auto => true
}
