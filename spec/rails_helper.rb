# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'spec_helper'
require 'devise'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }


# TODO soeren 08.09.2014 Rails 4.0.x
ActiveRecord::Migration.check_pending!

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
# Rails 4.1+
# TODO soeren 08.09.2014 ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.global_fixtures = :all

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller

  config.include FactoryGirl::Syntax::Methods

  # Mock des RSS-Feeds
  config.before(:each) do
    WebMock.stub_http_request(:get, RSS_FEED_URL).
        with(:headers => {'Accept' => '*/*'}).
        to_return(:status => 200, :body => "", :headers => {})
  end
end

def freeze_test_time(check_time=Time.now)
  allow(Time).to receive(:now).and_return(check_time)
end

def login user
  post 'user/sign_in', :user=>{ :email=>user.email, :password=>user.lastname }
end

def create_active_user(u = FactoryGirl.create(:user))
  u.confirmation_sent_at = 1.hour.ago
  u.confirm!
  u
end

def test_scheduler_actions
  ['hourly', 'admin']
end