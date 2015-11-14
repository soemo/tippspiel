# -*- encoding : utf-8 -*-
module NavBarHelper

  # controllername, path, needs_login
  def main_nav_items
    [
        ['main', root_path, false],
        ['tips', tips_path, true],
        ['tips_for_phone', tips_path({:for_phone => true}), true], # hat extra Behandlung in def write_main_nav - Extra Link auf dem Phone
        ['ranking', ranking_path, true],
        ['notice', notes_path, true],
        ['compare_tips', compare_tips_path, true],
        ['hall_of_fame', hall_of_fame_path, true],
        ['help', help_path, false]
    ]

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
      nav_items = nav_items.select{|i| !i[2] }
    end

    if nav_items.present?
      nav_items.each do |key, path, _|
        link_text = t(key)
        class_name = is_selected_controller?(key) ? 'active' : ''

        # TODO soeren 19.05.14 besser machen mit Rails4 #72 besser machen
        # Tipp Link wird 2 mal angegeben, einmal fuer Phone und der andere fuer Tablet und Desktop
        if key == 'tips'
          haml_tag "li.#{class_name}.hide-for-small-only" do
            haml_concat link_to(link_text, path)
          end
        elsif key == 'tips_for_phone'
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
      sub_menu_id = MAIN_NAV_USER_SUBMENU_ID
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
                haml_concat link_to(link[:text], link[:url])
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
            haml_concat link_to(link[:text], link[:url])
          end
        end
      end
    end
  end

  # main subnavigation
  def get_main_subnavigation_array
    result = {}
    result[MAIN_NAV_USER_SUBMENU_ID] =
        {:links => [
            {:text => t(:your_ranking_per_game), :url => user_ranking_per_game_path},
            {:text => t(:password_change), :url => user_edit_password_path},
            {:divider => true},
            {:text => t(:sign_out), :url => logout_path}
        ]}

    result
  end


end