class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :ensure_migrated
  before_filter :authenticate_user!
  before_filter :set_host_to_mailers

  include ExceptionHandling

  private

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
end
