# -*- encoding : utf-8 -*-
require 'pp'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.global_fixtures = :all

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures = false

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
  Time.should_receive(:now).any_number_of_times.and_return(check_time)
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

