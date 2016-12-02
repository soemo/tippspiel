# Im Mail Betreff soll immer der App-Name am Anfang stehen
module DeviseMailerHelperHeaderForWithAppNamePrefix
  def headers_for(action, opts)
    headers = super(action, opts)
    if headers[:subject].present?
      headers[:subject] = "#{I18n.t('app_name')} - #{headers[:subject]}"
    end
    headers
  end
end

Devise::Mailers::Helpers.prepend(::DeviseMailerHelperHeaderForWithAppNamePrefix)
