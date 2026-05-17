# frozen_string_literal: true

# Im Mail Betreff soll immer der App-Name am Anfang stehen
module DeviseMailerHelperHeaderForWithAppNamePrefix
  def headers_for(action, opts)
    headers = super
    headers[:subject] = "#{I18n.t('app_name')} - #{headers[:subject]}" if headers[:subject].present?
    headers
  end
end

Devise::Mailers::Helpers.prepend(DeviseMailerHelperHeaderForWithAppNamePrefix)
