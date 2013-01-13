# -*- encoding : utf-8 -*-
module ApplicationHelper

  # angepasste devise Methode
  def custom_devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.join("<br/>")
    html = <<-HTML
      <div id="error_explanation" class="alert alert-error">
        #{messages}
      </div>
    HTML

    html.html_safe
  end

  # controllername, path, needs_login
  def main_nav_items
    [
            ["main", root_path, false],
            ["tipps", tipps_path, true],
            ["ranking", ranking_path, true],
            ["notice", notice_path, true],
            ["help", help_path, false]
    ]

  end

  def icon_with_text(icon_name, text="dummytext", add_on_ccs_class="")
    icon_name.present? ? "<i class='#{icon_name} #{add_on_ccs_class}'></i>".html_safe + " " + text : text
  end

  def write_countdown
    haml_tag "div#countdown_dashboard" do
      haml_tag "div.dash.weeks_dash" do
        haml_tag "span.dash_title", "Wochen"
        haml_tag "div.digit", 0
        haml_tag "div.digit", 0
      end
      haml_tag "div.dash.days_dash" do
        haml_tag "span.dash_title", "Tage"
        haml_tag "div.digit", 0
        haml_tag "div.digit", 0
      end
      haml_tag "div.dash.hours_dash" do
        haml_tag "span.dash_title", "Stunden"
        haml_tag "div.digit", 0
        haml_tag "div.digit", 0
      end
      haml_tag "div.dash.minutes_dash" do
        haml_tag "span.dash_title", "Minuten"
        haml_tag "div.digit", 0
        haml_tag "div.digit", 0
      end
      # Sekunden aktuell raus
      #haml_tag "div.dash.seconds_dash" do
      #  haml_tag "span.dash_title", "Sekunden"
      #  haml_tag "div.digit", 0
      #  haml_tag "div.digit", 0
      #end
    end
  end

  def get_title
    t('tournament_name') + " " + t('app_name')
  end

  def write_team_with_flag(team_name, flag_icon_path="", spacer=nil)
    haml_concat image_tag(flag_icon_path, :class=>"team_flag") if flag_icon_path.present?
    haml_concat spacer if spacer.present?
    haml_concat team_name
  end

  def default_sidebar_content
    # im Fehlerfall wird keine Sidebar angezeigt
    unless controller.controller_name == "main" && controller.action_name == "error"
      write_sidebar_links
      write_sidebar_notes
      write_sidebar_rss_feed(@rss_title, @last_rss_entries)
      write_extern_links
    end
  end

  def write_sidebar_links
    if current_user.present?
      haml_tag :h5 do
        haml_concat link_to(t("compare_tipps"), compare_tipps_path)
      end
      haml_tag :h5 do
        haml_concat link_to(t("hall_of_fame"), hall_of_fame_path)
      end
      haml_tag :hr
    end
  end

  def write_extern_links
    haml_tag :h4, 'Links'
    haml_tag :br
    haml_tag :p do
      haml_concat link_to("EM Planer [PDF]", "http://motzigemba.de/files/planer2012.pdf", :target =>"_blank")
      haml_tag :br
      haml_concat link_to("UEFA", "http://de.uefa.com/uefaeuro/", :target =>"_blank")
      haml_tag :br
      haml_concat link_to("EM2012 Wikipedia", "http://de.wikipedia.org/wiki/Fu%C3%9Fball-Europameisterschaft_2012", :target=>"_blank")
      haml_tag :br
      haml_concat link_to("EM2012 Sportschau", "http://www.sportschau.de/uefaeuro2012/", :target=>"_blank")
    end
    haml_tag :hr
  end

  def write_sidebar_notes
    if current_user.present?
      notes = Notice.limit(5).all
      if notes.present?
        haml_tag :h4, t("notice")
        haml_tag :br
        notes.each do |n|
          haml_tag :p do
            haml_tag "span.notice_user", n.user.name if n.user.present?
            haml_tag :br
            haml_concat html_escape(n.text)
          end
        end
      end
      haml_concat link_to(t("write_notice"), notice_path)
      haml_tag :br
      haml_tag :hr
    end
  end

  def write_sidebar_rss_feed(title, entries)
    haml_tag :h4, title if title.present?
    haml_tag :br
    if entries.present?
      entries.each do |e|
        haml_tag :p do
          haml_tag "span.rss_date", l(e["date_published"].to_date)
          haml_tag :br
          haml_concat link_to(e["title"], e["urls"][0], :target => "_blank")
          haml_tag :br
          haml_concat e["content"]
        end
      end
    end
    haml_tag :hr
  end

  def write_main_nav
    nav_items = main_nav_items
    unless user_signed_in?
      nav_items = main_nav_items.select{|i| i[2] == false}
    end
    if nav_items.present?
      haml_tag 'ul.nav' do
        nav_items.each do |key, path, needs_login|
          class_name = key == controller.controller_name ? "active" : ""
          haml_tag "li.#{class_name}" do
            haml_concat link_to t(key), path
          end
        end
      end
    end
  end

  def write_auth_nav
    write_user_login_logout_link
    write_user_sign_up_link
  end

  def write_user_login_logout_link
    if user_signed_in?
      haml_concat t(:signed_in_hello)
      haml_concat current_user.firstname + " | "
      haml_concat link_to(icon_with_text("icon-off", t(:sign_out), "icon-white"), destroy_user_session_path)
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
