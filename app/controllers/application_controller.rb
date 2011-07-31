require 'exceptions'

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
    render :text => t(:text_maintenance) if ActiveRecord::Migrator.new(:up, "db/migrate/").pending_migrations.any?
  end
end
