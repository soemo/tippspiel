module ApplicationHelper

  # controllername, path, needs_login
  def main_nav_items
    [
            ["home", root_path, false],
            ["tipps", tipps_path, true],
            ["ranking", ranking_path, true],
            ["help", help_path, false]
    ]

  end

  def get_title
    t('app_name') + " " + t('tournament_name')
  end

  def write_main_nav
    nav_items = main_nav_items
    unless user_signed_in?
      nav_items = main_nav_items.select{|i| i[2] == false}
    end
    if nav_items.present?
      haml_tag 'ul.nav' do
        # # FIXME soeren 10.10.11 <li class="active">
        nav_items.each do |key, path, needs_login|
          haml_tag :li do
            haml_concat link_to t(key), path
          end
        end
      end
    end
  end

  def write_auth_nav
    write_user_login_logout_link
    write_user_sign_up_link
    haml_concat link_to(t(:imprint), help_path + "#imprint")
  end

  def write_user_login_logout_link
    if user_signed_in?
      haml_concat t(:signed_in_hello)
      haml_concat current_user.name
      haml_concat link_to(t(:sign_out), destroy_user_session_path)
    else
      haml_concat ""
    end
  end

  def write_user_sign_up_link
    if user_signed_in?
      haml_concat ""
    else
      haml_concat link_to(t(:sign_up), new_user_registration_path)
    end
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