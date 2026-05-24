# frozen_string_literal: true

module Rack
  # Minimal maintenance-mode middleware.
  #
  # When +file+ exists on disk every request returns 503 with the file's
  # contents, except requests whose PATH_INFO matches +bypass+.
  #
  # Used in production to display a static page while Capistrano deploys are
  # running (capistrano-maintenance uploads/removes the file around each deploy).
  class MaintenancePage
    BYPASS_PATH = '/health_check'

    def initialize(app, file)
      @app  = app
      @file = file
    end

    def call(env)
      if maintenance? && env['PATH_INFO'] != BYPASS_PATH
        body = File.read(@file)
        [503, { 'Content-Type' => 'text/html; charset=utf-8', 'Content-Length' => body.bytesize.to_s }, [body]]
      else
        @app.call(env)
      end
    end

    private

    def maintenance?
      File.exist?(@file)
    end
  end
end
