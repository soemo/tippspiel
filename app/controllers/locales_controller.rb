class LocalesController < ApplicationController
  skip_before_action :authenticate_user!

  def update
    locale = params[:locale].to_s
    session[:locale] = if SUPPORTED_LOCALES.include?(locale)
                         locale
                       else
                         I18n.default_locale.to_s
                       end
    redirect_back(fallback_location: root_path)
  end
end
