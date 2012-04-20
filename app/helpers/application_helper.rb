module ApplicationHelper

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

  def get_title
    t('app_name') + " " + t('tournament_name')
  end

  def default_sidebar_content
    write_sidebar_notes
    write_sidebar_rss_feed(@rss_title, @last_rss_entries)
  end

  def write_sidebar_notes
    if current_user.present?
      notes = Notice.limit(5).all
      if notes.present?
        haml_tag :h4, t("notice")
        notes.each do |n|
          haml_tag :p do
            haml_tag "span.notice_user", n.user.name
            haml_tag :br
            haml_concat n.text
          end
        end
      end
      haml_concat link_to(t("write_notice"), notice_path)
      haml_tag :br
      haml_tag :br
    end
  end

  def write_sidebar_rss_feed(title, entries)
    haml_tag :h4, title if title.present?
    haml_tag :br
    if entries.present?
      entries.each do |e|
        haml_tag :p do
          haml_tag "span.rss_date", l(e.date_published)
          haml_tag :br
          haml_concat link_to(e.title, e.url, :target => "_blank")
          haml_tag :br
          haml_concat e.content
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
        # # FIXME soeren 10.10.11 <li class="active">
        nav_items.each do |key, path, needs_login|
          class_name = key == controller.controller_name ? "active" : ""
          pp "test sm" # FIXME soeren 20.04.12
          pp controller.controller_name
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