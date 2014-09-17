# Angepasst, damit unsere eigenen Felder auf dem Registrierungsform zu den Strong Parametern von Devise hinzukommen
class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:firstname, :lastname)
  end
end