# frozen_string_literal: true

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
    I18n.locale = resolve_locale
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

  private

  def resolve_locale
    locale_from_session || locale_from_header || I18n.default_locale
  end

  def locale_from_session
    locale = session[:locale]
    locale if locale.present? && SUPPORTED_LOCALES.include?(locale)
  end

  def locale_from_header
    header = request.env['HTTP_ACCEPT_LANGUAGE']
    return nil if header.blank?

    header.split(',').map { |l| l.split(';q=').first.strip[0..1].downcase }
                     .find { |lang| SUPPORTED_LOCALES.include?(lang) }
  end

  def set_host_to_mailers
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
end
