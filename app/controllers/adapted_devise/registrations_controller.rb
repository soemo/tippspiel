# Angepasst, damit unsere eigenen Felder auf dem Registrierungsform zu den Strong Parametern von Devise hinzukommen
module AdaptedDevise
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters
    before_action :check_permission

    protected

    def check_permission
      render_forbidden if Tournament.finished? # registration is allowed before and on every tournament day
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname, :create_initial_random_tips])
    end

    def after_inactive_sign_up_path_for(_)
      root_path(signed_up_message: 1)
    end
  end
end