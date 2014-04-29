# -*- encoding : utf-8 -*-
module ApplicationHelper

  # angepasste devise Methode
  def custom_devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.join('<br/>')
    html = <<-HTML
      <div id='error_explanation' class='alert alert-error'>
        #{messages}
      </div>
    HTML

    html.html_safe
  end

  # controllername, path, needs_login
  def main_nav_items
    [
            ['main', root_path, false],
            ['tipps', tipps_path, true],
            ['ranking', ranking_path, true],
            ['notice', notice_path, true],
            ['help', help_path, false]
    ]

  end

  def icon_with_text(icon_name, text='dummytext', add_on_ccs_class='')
    icon_name.present? ? "<i class='#{icon_name} #{add_on_ccs_class}'></i>".html_safe + ' ' + text : text
  end

  def get_title
    "#{TOURNAMENT_NAME} #{t('app_name')}"
  end

  def write_team_with_flag(team_name, country_code='', spacer=nil)
    if country_code.present?
      haml_tag 'span.f16' do
        haml_tag "i.flag.#{country_code}"
      end
    end
    haml_concat spacer if spacer.present?
    haml_concat team_name
  end

  def default_sidebar_content
    # im Fehlerfall wird keine Sidebar angezeigt
    unless controller.controller_name == 'main' && controller.action_name == 'error'
      haml_concat render_cell(:user_sidebar_links, :show, :user => current_user)
      haml_concat render_cell(:sidebar_notes, :show, :user => current_user, :item_count => 5, :last_updated_at => Notice.last_updated_at)
      haml_concat render_cell(:rss_feed, :show, :item_count => 5)
      haml_concat render_cell(:extern_links, :show)
    end
  end

  def write_navbar
    haml_tag 'div.navbar.navbar-fixed-top' do
      haml_tag 'div.navbar-inner' do
        haml_tag 'div.container' do
          haml_tag 'a.btn.btn-navbar', {'data-toggle' => 'collapse', 'data-target' => '.nav-collapse'} do
            haml_tag 'span.icon-bar'
            haml_tag 'span.icon-bar'
            haml_tag 'span.icon-bar'
          end
          haml_tag 'a.brand', {:href=> '/'} do
            haml_concat image_tag('soccer_Ball.png', :class=>'soccer_ball') + get_title
          end
          if FEATURE_BETA_TEXT.present?
            haml_tag 'a.brand', {:href=>'#'} do
              haml_concat '<span class="label label-warning beta-label">BETA</span>'
            end
          end

          haml_tag 'div.nav-collapse.collapse' do
            write_main_nav
            write_auth_nav
          end
        end
      end
    end
  end

  def write_main_nav
    nav_items = main_nav_items
    unless user_signed_in?
      nav_items = main_nav_items.select{|i| i[2] == false}
    end
    if nav_items.present?
      haml_tag 'ul.nav' do
        nav_items.each do |key, path, needs_login|
          class_name = key == controller.controller_name ? 'active' : ''
          haml_tag "li.#{class_name}" do
            haml_concat link_to t(key), path
          end
        end
      end
    end
  end

  def write_auth_nav
    if user_signed_in?
      haml_tag 'ul.nav.pull-right' do
        haml_tag 'li.divider-vertical'
        sub_menu_id = MAIN_NAV_ITEM_CURRENT_USER_SUBMENU_ID
        css_class = (controller_name == 'user')  ? 'active' : ""
        sub_menu = get_main_subnavigation_array
        nav_text = get_user_name_or_sign_in_link
        if sub_menu[sub_menu_id].present?
          write_sub_menu(sub_menu_id, sub_menu[sub_menu_id][:links], nav_text, css_class)
        end
      end
    end  # no else
  end

  def write_sub_menu(sub_menu_id, links, main_menu_text, css_class='')
    if sub_menu_id.present? && links.present? && main_menu_text.present?
      haml_tag "li##{sub_menu_id}.dropdown.#{css_class}" do

        haml_tag :a, {:href => '#', 'data-toggle' => 'dropdown', :class=>'dropdown-toggle'} do
          haml_concat main_menu_text
          haml_tag 'b.caret'
        end
        haml_tag 'ul.dropdown-menu' do
          links.each do |link|
            if link[:divider].present?
              haml_tag 'li.divider'
            else
              haml_tag :li do
                haml_concat link_to(link[:text], link[:url])
              end
            end
          end
        end

      end
    end
  end

  # main subnavigation
    def get_main_subnavigation_array
      result = {}
      result[MAIN_NAV_ITEM_CURRENT_USER_SUBMENU_ID] =
          {:links => [
              {:text => t(:password_change), :url => user_edit_password_path},
              {:divider => true},
              {:text => icon_with_text('icon-off', t(:sign_out), 'icon'), :url => destroy_user_session_path}
          ]}

      result
    end


  def get_user_name_or_sign_in_link
    if user_signed_in?
      "#{t(:signed_in_hello)} #{current_user.firstname}"
    else
      link_to(t(:sign_up), new_user_registration_path)
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
