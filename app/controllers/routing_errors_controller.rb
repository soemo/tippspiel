# frozen_string_literal: true

class RoutingErrorsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  # In the case of a unknown route is called we delegate to this action and throw manually
  # the ActionController::RoutingError. This is necessary to let ExceptionNotification handle this error by sending
  # an error mail because normally ActionController::RoutingError is already called in the middleware where
  # ExceptionNotification is not yet aware of it up to version 4.1.4.
  #
  # Bot/scanner probes (WordPress, PHP, .env harvesting, .git probes) are silently returned
  # as 404 without raising an exception, to avoid noise in logs and notification emails.
  def show
    path = params[:unknown_route].to_s
    raise ActionController::RoutingError, "Unknown route #{path}" unless bot_scan?(path)

    head :not_found
  end

  private

  def bot_scan?(path)
    # PHP file probes (WordPress exploit scanners, generic PHP probes)
    return true if path.end_with?('.php') || path.match?(/\.php\d*\z/i)
    # WordPress-specific paths
    return true if path.start_with?('wp-', 'wp-content/', 'wp-admin/', 'wp-includes/')
    # Credential/config file harvesting and git probes
    return true if path.start_with?('.env', '.git/', 'cgi-bin')
    # .env files nested in subdirectories (e.g. app/.env, laravel/.env, api/v1/.env)
    return true if path.match?(/\.env[\w.\-~]*\z/)

    false
  end
end
