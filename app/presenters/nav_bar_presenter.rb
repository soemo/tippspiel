class NavBarPresenter
  include Rails.application.routes.url_helpers

  attr_reader :url_scope, :user

  def initialize(url_scope, user)
    @url_scope = url_scope
    @user = user
  end

  def active_css_class(effective_url_scope)
    url_scope == effective_url_scope ? 'active' : ''
  end

  def nav_bar_brand_url
    root_path
  end

  def nav_bar_item_presenters
    nav_bar_item_configurations.map{ |item_config|
      nav_bar_item_presenter(item_config)
    }
  end

  def nav_bar_item_user_presenter
    nav_bar_item_presenter(nav_bar_item_user_configuration)
  end

  def user_logged_in?
    user.present?
  end

  private

  def nav_bar_item_presenter(config)
    NavBarItemPresenter.new(config[:link_text],
                            config[:link_url],
                            config[:sub_menu_id],
                            config[:sub_menu_links],
                            config[:css_class])
  end

  def nav_bar_item_configurations
    result = []
    if user_logged_in?
      result += [
          {link_text: I18n.t('tips'),
           link_url: tips_path,
           css_class: active_css_class(URL_SCOPES[:tips])}
      ]
      result += [
          {link_text: I18n.t('ranking'),
           link_url: ranking_path,
           css_class: active_css_class(URL_SCOPES[:ranking])}
      ]
      result += [
          {link_text: I18n.t('notice'),
           link_url: notes_path,
           css_class: active_css_class(URL_SCOPES[:notes])}
      ]
      result += [
          {link_text: I18n.t('comparetips'),
           link_url: compare_tips_path,
           css_class: active_css_class(URL_SCOPES[:comparetips])}
      ]
    end

    result + [{link_text: I18n.t('.help'),
               link_url: help_path,
               css_class: active_css_class(URL_SCOPES[:help])}]

  end

  def nav_bar_item_user_configuration
    result = {}
    if user_logged_in?
      result =  {link_text: "#{I18n.t(:signed_in_hello)} #{user.firstname}",
                 link_url: nil,
                 sub_menu_id: :current_user_sub_menu,
                 sub_menu_links: [
                     {link_text: I18n.t(:your_ranking_per_game), link_url: user_ranking_per_game_path},
                     {link_text: I18n.t(:password_change), link_url: user_edit_password_path},
                     {divider: true},
                     {link_text: I18n.t(:hall_of_fame), link_url: user_hall_of_fame_path},
                     {divider: true},
                     {link_text: I18n.t(:sign_out), link_url: logout_path}
                 ],
                 css_class: active_css_class(URL_SCOPES[:user])
      }
    end

    result
  end

end
