class NavBarPresenter
  include Rails.application.routes.url_helpers
  include ApplicationHelper

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

  def nav_bar_title
    if user_logged_in?
      "#{TOURNAMENT_NAME} #{I18n.t('your_tips')}"
    else
      get_title
    end
  end

  def user_position
    @position ||= begin
      result = Users::Top3AndOwnPosition.call(user_id: user.id)
      result.own_position
    end
  end

  def nav_ranking_info
    "Platz #{user_position} mit #{user.points} Punkten"
  end

  def nav_bar_item_presenters
    nav_bar_item_configurations.map{ |item_config|
      nav_bar_item_presenter(item_config)
    }
  end

  def user_logged_in?
    user.present?
  end

  private

  def nav_bar_item_presenter(config)
    NavBarItemPresenter.new(config[:link_icon_prefix],
                            config[:link_icon],
                            config[:link_text],
                            config[:link_url],
                            config[:css_class])
  end

  def nav_bar_item_configurations
    result = []
    if user_logged_in?
      result += [
        {link_icon_prefix: 'fas',
         link_icon: 'rocket',
         link_text: I18n.t('bonus'),
         link_url: edit_bonus_path,
         css_class: active_css_class(URL_SCOPES[:bonus])}
      ]
      result += [
        {link_icon_prefix: 'fas',
         link_icon: 'list-ol',
         link_text: I18n.t('ranking'),
         link_url: rankings_path,
         css_class: active_css_class(URL_SCOPES[:ranking])}
      ]
      result += [
        {link_icon_prefix: 'far',
         link_icon: 'comments',
         link_text: I18n.t('notice'),
         link_url: notes_path,
         css_class: active_css_class(URL_SCOPES[:notes])}
      ]
      result += [
        {link_icon_prefix: 'fas',
         link_icon: 'angle-double-right',
         link_text: I18n.t('comparetips'),
         link_url: compare_tips_path,
         css_class: active_css_class(URL_SCOPES[:comparetips])}
      ]
    end

    result += [{link_icon_prefix: 'far',
                link_icon: 'question-circle',
                link_text: nil,
                link_url: help_path,
                css_class: active_css_class(URL_SCOPES[:help])}]

    if user_logged_in?
      result +=  [{link_icon_prefix: 'fas',
                   link_icon: 'sign-out-alt',
                   link_text: I18n.t(:sign_out),
                   link_url: logout_path,
                   css_class: active_css_class(URL_SCOPES[:user])
                  }]
    end

    result
  end
end
