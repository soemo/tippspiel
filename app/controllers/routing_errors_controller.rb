class RoutingErrorsController < ApplicationController

  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  # In the case of a unknown route is called we delegate to this action and throw manually
  # the ActionController::RoutingError. This is necessary to let ExceptionNotification handle this error by sending
  # an error mail because normally ActionController::RoutingError is already called in the middleware where
  # ExceptionNotification is not yet aware of it up to version 4.1.4.
  def show
    raise ActionController::RoutingError, "Unknown route #{params[:unknown_route]}"
  end
end
