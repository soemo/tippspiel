class LocalesController < ApplicationController
  skip_before_action :authenticate_user!

  def update
    locale = params[:locale].to_s
    session[:locale] = if SUPPORTED_LOCALES.include?(locale)
                         locale
                       else
                         I18n.default_locale.to_s
                       end
    redirect_to safe_return_path
  end

  private

  def safe_return_path
    referer = request.referer
    return fallback_locale_path unless referer.present?

    # Only redirect back if the referer resolves to a routable GET path.
    # Devise's registration POST renders at /users which has no GET route —
    # redirecting back there would trigger a RoutingError.
    referer_path = URI.parse(referer).path
    begin
      match = Rails.application.routes.router.recognize({ 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => referer_path, 'rack.input' => StringIO.new }) { |route, _| route }
      match ? referer : fallback_locale_path
    rescue StandardError
      fallback_locale_path
    end
  rescue URI::InvalidURIError
    fallback_locale_path
  end

  def fallback_locale_path
    user_signed_in? ? root_path : new_user_registration_path
  end
end
