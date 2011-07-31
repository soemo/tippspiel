ActionMailer::Base.smtp_settings = {
        :address => "smtp.soemo.org",
        :port => 25,
        :user_name => "postfach@soemo.org",
        :password => "harald",
        :authentication => :login
}