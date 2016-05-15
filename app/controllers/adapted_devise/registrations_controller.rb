# Angepasst, damit unsere eigenen Felder auf dem Registrierungsform zu den Strong Parametern von Devise hinzukommen
module AdaptedDevise
  class RegistrationsController < Devise::RegistrationsController
    before_filter :configure_permitted_parameters

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up).push(:firstname, :lastname)
    end

    def after_inactive_sign_up_path_for(_)
      root_path(signed_up_message: 1)
    end
  end
end