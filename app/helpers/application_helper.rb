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
    "#{t('tournament_name')} #{t('app_name')}"
  end

  def write_team_with_flag(team_name, flag_icon_path='', spacer=nil)
    haml_concat image_tag(flag_icon_path, :class=>'team_flag') if flag_icon_path.present?
    haml_concat spacer if spacer.present?
    haml_concat team_name
  end

  def default_sidebar_content
    # im Fehlerfall wird keine Sidebar angezeigt
    unless controller.controller_name == 'main' && controller.action_name == 'error'
      write_sidebar_links
      write_sidebar_notes
      write_sidebar_rss_feed(@rss_title, @last_rss_entries)
      write_extern_links
    end
  end

  def write_sidebar_links
    if current_user.present?
      haml_tag :h5 do
        haml_concat link_to(t('compare_tipps'), compare_tipps_path)
      end
      haml_tag :h5 do
        haml_concat link_to(t('hall_of_fame'), hall_of_fame_path)
      end
      haml_tag :hr
    end
  end

  def write_extern_links
    haml_tag :h4, 'Links'
    haml_tag :p do
      if SIDEBAR_EXTERN_LINKS.present?
        SIDEBAR_EXTERN_LINKS.each do |link_data|
          haml_concat link_to(link_data[:title], link_data[:url], :target =>'_blank')
          haml_tag :br
        end
      end
    end
    haml_tag :hr
  end

  def write_sidebar_notes
    if current_user.present?
      notes = Notice.limit(5).all
      if notes.present?
        haml_tag 'h4.wrap_text', t('notice')
        notes.each do |n|
          haml_tag 'span.notice_user', n.user.name if n.user.present?
          haml_tag 'p.wrap_text', html_escape(n.text)
        end
      end
      haml_concat link_to(t('write_notice'), notice_path)
      haml_tag :br
      haml_tag :hr
    end
  end

  def write_sidebar_rss_feed(title, entries)
    haml_tag 'h4.wrap_text', title if title.present?
    if entries.present?
      entries.each do |e|
        haml_tag :p do
          haml_tag 'span.rss_date', l(e['date_published'].to_date)
          haml_tag :br
          haml_concat link_to(e['title'], e['urls'][0], :target => '_blank')
          haml_tag :br
          haml_tag 'span.wrap_text', raw(e['content'])
        end
      end
    end
    haml_tag :hr
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
