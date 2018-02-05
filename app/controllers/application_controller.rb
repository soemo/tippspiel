require 'pp'
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  include ErrorHandling
  include HttpStatusCodeRenderers

  before_action :set_locale
  before_action :authenticate_user!
  before_action :set_host_to_mailers

  helper_method :current_user, :nav_bar_presenter

    # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def set_locale
    I18n.locale = I18n.default_locale
  end

  def set_host_to_mailers
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def nav_bar_presenter
    NavBarPresenter.new(url_scope, current_user)
  end

  def url_scope
    @url_scope ||= begin
      url_scope = ''
      path = request.path

      URL_SCOPES.each_value do |value|

        if path.starts_with?("/#{value}")
          url_scope = value
          break
        end
      end

      url_scope.inquiry
    end
  end
end
