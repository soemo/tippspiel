module DeviceHelper

  # angepasste devise Methode
  def custom_devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.join('<br/>')
    html = <<-HTML
      <div data-closable class='alert-box alert'>
        #{messages}
        <button class="close-button" data-close>&times;</button>
      </div>
    HTML

    html.html_safe
  end

  # https://github.com/plataformatec/devise/wiki/How-To:-Display-a-custom-sign_in-form-anywhere-in-your-app
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end


end