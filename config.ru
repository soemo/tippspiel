# This file is used by Rack-based servers to start the application.

=begin
require_relative "config/environment"

run Rails.application
Rails.application.load_server
=end

require ::File.expand_path('../config/environment',  __FILE__)
run Tippspiel::Application
