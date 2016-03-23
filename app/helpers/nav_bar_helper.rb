# -*- encoding : utf-8 -*-
module NavBarHelper

  # controllername, path, needs_login
  def main_nav_items
    [
        ['tips', tips_path, true],
        ['ranking', ranking_path, true],
        ['notice', notes_path, true],
        ['compare_tips', compare_tips_path, true],
        ['hall_of_fame', hall_of_fame_path, true],
        ['help', help_path, false]
  ]

  end

  def write_menu_text
    haml_tag :span do
      haml_tag 'a.brand', {:href=> '/'} do
        haml_concat image_tag('soccer_ball.png', :class=>'soccer_ball', size: '16x16')
        haml_concat get_title
      end
    end
  end


  def write_navbar

    # off-canvas title bar for 'small' screen
    haml_tag :div,
             class: 'title-bar',
             data: {'responsive-toggle': 'widemenu',
                    'hide-for': 'large'}  do
       haml_tag :div, class: 'title-bar-left' do
         haml_tag :button,
                  class: 'menu-icon dark',
                  type: 'button',
                  data: {open: 'offCanvasLeft'}
         haml_tag :span, class: 'title-bar-title' do
           write_menu_text
         end
       end
    end

    # off-canvas left menu
    haml_tag :div,
             class: 'off-canvas position-left',
             id: 'offCanvasLeft',
             data: {'off-canvas': ''} do
      haml_tag :ul,
               class: 'vertical dropdown menu',
               data: {'dropdown-menu': ''} do
        write_main_nav
        write_auth_nav(true)
      end
    end

    # "wider" top-bar menu for 'medium' and up
    haml_tag :nav, class: 'column row' do
      haml_tag :div, id: 'widemenu', class: 'top-bar' do
        haml_tag :div, class: 'top-bar-left' do
          haml_tag :ul, class: 'menu' do
            haml_tag :li, class: 'menu-text' do
              write_menu_text
            end
            write_main_nav
           end
        end
        haml_tag :div, class: 'top-bar-right' do
          haml_tag :ul, class: 'dropdown menu', data: {'dropdown-menu': ''} do
            write_auth_nav
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
        # FIXME soeren 3/13/16 Presenter nutzen um den active Tab zu markieren. see TTBN
        class_name = is_selected_controller?(key) ? 'active' : ''

        haml_tag "li.#{class_name}" do
          haml_concat link_to(link_text, path)
        end
      end
    end
  end

  def write_auth_nav(for_off_canvas = false)
    if user_signed_in?
      sub_menu_id = MAIN_NAV_USER_SUBMENU_ID
      css_class = (controller_name == 'user')  ? 'active' : ''
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
      haml_tag "li##{sub_menu_id}.#{css_class}" do

        haml_tag :a, main_menu_text
        haml_tag 'ul.menu vertical' do
          links.each do |link|
            if link[:divider].present?
              haml_tag :li do
                haml_tag :hr
              end
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
        haml_tag :hr
      end

      links.each do |link|
        if link[:divider].present?
          haml_tag :li do
            haml_tag :hr
          end
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