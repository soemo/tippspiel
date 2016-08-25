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

  def nav_ranking_info
    result = Users::Top3AndOwnPosition.call(user_id: user.id)
    "Du bist mit #{user.points} Punkten auf dem #{result.own_position}. Platz!"
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
    NavBarItemPresenter.new(config[:link_icon],
                            config[:link_text],
                            config[:link_url],
                            config[:css_class])
  end

  def nav_bar_item_configurations
    result = []
    if user_logged_in?
      result += [
          {link_icon: 'list-ol',
           link_text: I18n.t('ranking'),
           link_url: ranking_path,
           css_class: active_css_class(URL_SCOPES[:ranking])}
      ]
      result += [
          {link_icon: 'comment',
           link_text: I18n.t('notice'),
           link_url: notes_path,
           css_class: active_css_class(URL_SCOPES[:notes])}
      ]
      result += [
          {link_icon: 'angle-double-right',
           link_text: I18n.t('comparetips'),
           link_url: compare_tips_path,
           css_class: active_css_class(URL_SCOPES[:comparetips])}
      ]
    end

    result += [{link_icon: 'question',
                link_text: nil,
                link_url: help_path,
                css_class: active_css_class(URL_SCOPES[:help])}]

    if user_logged_in?
      result +=  [{link_icon: 'sign-out',
                  link_text: I18n.t(:sign_out),
                  link_url: logout_path,
                  css_class: active_css_class(URL_SCOPES[:user])
      }]
    end

    result
  end
end
