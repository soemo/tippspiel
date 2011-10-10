module ApplicationHelper

  # controllername, path, needs_login
  def main_nav_items
    [
            ["home", root_path, false],
            ["tournament", tournament_index_path, true],
            ["tipps", tipps_index_path, true],
            ["ranking", ranking_index_path, true],
            ["help", help_index_path, false]
    ]

  end

  def write_main_nav
    nav_items = main_nav_items
    unless user_signed_in?
      nav_items = main_nav_items.select{|i| i[2] == false}
    end
    if nav_items.present?
      haml_tag :ul do
        # # FIXME soeren 10.10.11 <li class="current_page_item">
        nav_items.each do |key, path, needs_login|
          haml_tag :li do
            haml_concat link_to t(key), path
          end
        end
      end
    end
  end

  def write_global_nav
    haml_tag :ul do
      haml_tag :li do
        write_user_login_logout_link
      end
      haml_tag :li do
        write_user_sign_up_link
      end
      haml_tag :li, link_to(t(:imprint), help_index_path)
    end
  end

  def write_user_login_logout_link
    if user_signed_in?
      haml_concat t(:signed_in_hello)
      haml_concat current_user.name
      haml_concat link_to(t(:sign_out), destroy_user_session_path)
    else
      haml_concat link_to(t(:sign_in), new_user_session_path)
    end
  end

  def write_user_sign_up_link
    if user_signed_in?
      haml_concat ""
    else
      haml_concat link_to(t(:sign_up), new_user_registration_path)
    end
  end

end