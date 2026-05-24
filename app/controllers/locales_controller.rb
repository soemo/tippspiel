# frozen_string_literal: true

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
    return fallback_locale_path if referer.blank?

    referer_path = URI.parse(referer).path

    # Signed-in users can always go back to where they were.
    # Unauthenticated users may only return to public pages to avoid an
    # authenticate_user! redirect loop.
    if user_signed_in? || public_path?(referer_path)
      referer
    else
      fallback_locale_path
    end
  rescue URI::InvalidURIError
    fallback_locale_path
  end

  def public_path?(path)
    public_controllers = %w[devise/sessions devise/registrations imprints helps]
    route_info = Rails.application.routes.recognize_path(path, method: :get)
    public_controllers.include?(route_info[:controller])
  rescue ActionController::RoutingError, ActionController::MethodNotAllowed, NoMethodError
    false
  end

  def fallback_locale_path
    user_signed_in? ? root_path : new_user_session_path
  end
end
