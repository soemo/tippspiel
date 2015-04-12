# -*- encoding : utf-8 -*-
module ApplicationHelper

  # angepasste devise Methode
  def custom_devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.join('<br/>')
    html = <<-HTML
      <div data-alert id='error_explanation' class='alert-box alert'>
        #{messages}
      </div>
    HTML

    html.html_safe
  end

  # controllername, path, needs_login, font-awesome icon_class_name
  def main_nav_items
    [
            ['main', root_path, false, 'home'],
            ['tipps', tipps_path, true, 'bullseye'],
            ['tipps_for_phone', tipps_path({:for_phone => true}), true, 'bullseye'], # hat extra Behandlung in def write_main_nav - Extra Link auf dem Phone
            ['ranking', ranking_path, true, 'list-ol'],
            ['notice', notice_path, true, 'comment'],
            ['help', help_path, false, 'info']
    ]

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
      if current_user.present?
        haml_concat render_cell(:user_sidebar_links, :show)
        unless controller.controller_name == 'notice'
          haml_concat render_cell(:sidebar_notes, :show, :item_count => 5, :last_updated_at => Notice.last_updated_at)
        end
      end
      haml_concat render_cell(:extern_links, :show)
      haml_concat render_cell(:rss_feed, :show, :item_count => 5)
    end
  end

  def write_flash_messages
    haml_tag 'div#flash_messages' do
      write_flash(flash[:error], 'alert')
      write_flash(flash[:alert], 'alert')
      write_flash(flash[:notice], 'success')
    end

    flash.discard
  end

  def write_flash(msg, div_alert_css_class)
    if msg.kind_of?(Array)
      if msg.size > 1
        raise "Mehrelementige Textparameter verboten: #{msg}"
      else
        msg = msg.first
      end
    end

    if msg.present?
      haml_tag "div.alert-box.#{div_alert_css_class}", {'data-alert' => ''} do
        haml_tag 'a.close', {'data-dismiss' => 'alert'} do
          haml_concat '&times;'
        end
        haml_tag :p, msg
      end
    end
  end

  def write_navbar
    # 1. Navbar ist hide-for-small-only: Also sichtbar auf Tablett und groesser
    # 2. Navbar ist show-for-small-only: Off-Canvas Menu

    haml_tag 'div.contain-to-grid' do

      # 1.
      haml_tag 'nav.top-bar.hide-for-small-only', {data: {topbar: ''}, role: 'navigation'} do
        haml_tag 'ul.title-area' do
          haml_tag 'li.name' do
            haml_tag :h1 do
              haml_tag 'a.brand', {:href=> '/'} do
                haml_concat image_tag('soccer_ball.png', :class=>'soccer_ball')
                haml_concat get_title
                if FEATURE_BETA_TEXT.present?
                  haml_tag 'small.label.warning.round', 'BETA'
                end
              end
            end
          end
          haml_tag 'li.toggle-topbar.menu-icon' do
            haml_tag 'a', {href: "#"} do
              haml_tag :span, ''
            end
          end
        end

        haml_tag 'section.top-bar-section' do
          haml_tag 'ul.right' do
            write_main_nav
            write_auth_nav
          end

          haml_tag 'ul.left' do
            # wenn man links auch ein Menue haben will
          end
        end
      end

      # 2.
      haml_tag 'div.show-for-small-only' do
        haml_tag 'nav.tab-bar' do
          haml_tag 'section.left-small' do
            haml_tag 'a.left-off-canvas-toggle.menu-icon', {href: '#'} do
              haml_tag :span, ''
            end
          end

          haml_tag 'section.middle.tab-bar-section' do
            haml_tag 'h1.left' do
              haml_tag 'a.brand', {:href=> '/'} do
                haml_concat image_tag('soccer_ball.png', :class=>'soccer_ball')
                haml_concat get_title
                if FEATURE_BETA_TEXT.present?
                  haml_tag 'small.label.warning.round', 'BETA'
                end
              end
            end
          end
        end

        haml_tag 'nav.left-off-canvas-menu' do
          haml_tag 'ul.off-canvas-list' do
            write_main_nav
            write_auth_nav(true)
          end
        end

      end

    end

  end

  def write_main_nav
    nav_items = main_nav_items

    unless user_signed_in?
      nav_items = nav_items.select{|i| i[2] == false}
    end

    if nav_items.present?
      nav_items.each do |key, path, needs_login, icon_class_name|
        if icon_class_name.present?
          link_text = icon(icon_class_name, t(key))
        else
          link_text = t(key)
        end
        class_name = key == controller.controller_name ? 'active' : ''

        # TODO soeren 19.05.14 besser machen mit Rails4 #72 besser machen
        # Tipp Link wird 2 mal angegeben, einmal fuer Phone und der andere fuer Tablet und Desktop
        if key == 'tipps'
          haml_tag "li.#{class_name}.hide-for-small-only" do
            haml_concat link_to(link_text, path)
          end
        elsif key == 'tipps_for_phone'
          haml_tag "li.#{class_name}.show-for-small-only" do
            haml_concat link_to(link_text, path)
          end
        else
          haml_tag "li.#{class_name}" do
            haml_concat link_to(link_text, path)
          end
        end
      end
    end
  end

  def write_auth_nav(for_off_canvas = false)
    if user_signed_in?
      haml_tag 'li.divider'
      sub_menu_id = MAIN_NAV_ITEM_CURRENT_USER_SUBMENU_ID
      css_class = (controller_name == 'user')  ? 'active' : ""
      sub_menu = get_main_subnavigation_array
      nav_text = get_user_name_or_sign_in_link
      if sub_menu[sub_menu_id].present?
        if for_off_canvas
          write_sub_menu_for_off_canvas(sub_menu[sub_menu_id][:links], nav_text)
        else
          write_sub_menu(sub_menu_id, sub_menu[sub_menu_id][:links], nav_text, css_class)
        end
      end
    end  # no else
  end

  def write_sub_menu(sub_menu_id, links, main_menu_text, css_class='')
    if sub_menu_id.present? && links.present? && main_menu_text.present?
      haml_tag "li##{sub_menu_id}.has-dropdown.#{css_class}" do

        haml_tag :a,  main_menu_text
        haml_tag 'ul.dropdown' do
          links.each do |link|
            if link[:divider].present?
              haml_tag 'li.divider'
            else
              haml_tag :li do
                haml_concat link_to(icon(link[:icon_class], link[:text]), link[:url])
              end
            end
          end
        end

      end
    end
  end

  def write_sub_menu_for_off_canvas(links, main_menu_text)
    if links.present? && main_menu_text.present?
      haml_tag :li do
        haml_tag :label, main_menu_text
      end

      links.each do |link|
        if link[:divider].present?
          haml_tag 'li.divider'
        else
          haml_tag :li do
            haml_concat link_to(icon(link[:icon_class], link[:text]), link[:url])
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
            {:text => t(:password_change), :url => user_edit_password_path, icon_class: 'unlock-alt'},
            {:divider => true},
            {:text => t(:sign_out), :url => logout_path, icon_class: 'sign-out'}
        ]}

    result
  end


  def get_user_name_or_sign_in_link
    if user_signed_in?
      hello_user_name
    else
      link_to(t(:sign_up), new_user_registration_path)
    end
  end

  def hello_user_name
    "#{t(:signed_in_hello)} #{current_user.firstname}"
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

  def write_footer_content
     haml_tag 'p.text-center' do
       haml_concat "© " + Time.now.strftime("%Y")
       haml_concat link_to("Sören Mothes", "http://www.soemo.org/")
       haml_concat " | "
       haml_concat link_to(t(:imprint), help_path + "#imprint")
       haml_concat " |  version #{$TIPPSPIEL_VERSION} - #{$TIPPSPIEL_BUILD_DATE}"
     end
  end

end
