# -*- encoding : utf-8 -*-
require 'pp'
class ApplicationController < ActionController::Base
  protect_from_forgery

  include RssReader

  before_filter :ensure_migrated
  before_filter :set_locale
  before_filter :authenticate_user!
  before_filter :set_host_to_mailers
  before_filter :get_default_sidebar_content

  include ExceptionHandling

  helper_method :tournament_finished?, :before_tournament?, :current_user

  protected


  def get_default_sidebar_content
    @rss_title, @last_rss_entries = get_top_x_entries_and_title(RSS_FEED_URL, 5)
    @comments = Notice.limit(5).all
  end

  def tournament_finished?
    Game.tournament_finished?
  end

  def before_tournament?
    Game.before_tournament?
  end

  def set_locale
    I18n.locale = I18n.default_locale
    # TODO soeren 01.04.12 erstmal nur deutsch
    #logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    #I18n.locale = extract_locale_from_accept_language_header
    #logger.debug "* Locale set to '#{I18n.locale}'"
  end

  def set_host_to_mailers
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def ensure_migrated
    unless Rails.env == "production"
      if ActiveRecord::Migrator.new(:up, "db/migrate/").pending_migrations.any?
        text = (t(:text_maintenance, :locale => :en) + "<br/>" + t(:text_maintenance, :locale => :de)).html_safe
        if Rails.env == "test"
          raise text
        else
          render :text => text, :status => 503
        end
      end
    end
  end

  private

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

end
