# frozen_string_literal: true

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'logger'        # concurrent-ruby >= 1.3 lazy-loads logger; Rails 6.1 needs it at boot
