# -*- encoding : utf-8 -*-
require 'pp'
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  include ExceptionHandling

  before_filter :set_locale
  before_filter :authenticate_user!, :unless => :error_handling_method?
  before_filter :set_host_to_mailers

  helper_method :current_user

    # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def set_locale
    I18n.locale = I18n.default_locale
  end

  def set_host_to_mailers
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  private

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

end
