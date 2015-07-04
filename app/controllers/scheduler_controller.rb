# -*- encoding : utf-8 -*-
class SchedulerController < ApplicationController

  MIN_TIME_BETWEEN_RUNS = 5.minutes

  before_filter      :check_invoke_frequency, :except => :admin
  skip_before_filter :authenticate_user!

  def hourly
    start_calculate_points
    clean_invoke_table
    RssFeed::WriteCache.call(rss_feed_url: RSS_FEED_URL)
    render :plain => "Hourly scheduler run successful", :status => :ok
  end

  def admin
    start_calculate_points
    render :plain => "Admin scheduler run successful", :status => :ok
  end

  # TODO soeren 30.04.15 #94 refactoring
  private

  def start_calculate_points
    FootieFox::UpdateGames.call
    Tips::UpdatePoints.call
    Users::UpdatePoints.call
  end

  def check_invoke_frequency
    event_type = "scheduler_#{action_name}"
    last_run = Event.order(:created_at).where(:event_type => event_type).last
    if last_run.present? && last_run.created_at > MIN_TIME_BETWEEN_RUNS.ago
      render :plain => "scheduler should not run that often", :status => :bad_request
    else
      Event.create! :event_type => event_type
    end
  end

  def clean_invoke_table
    Event.delete_all(["created_at < ?", 1.month.ago.to_s(:db)])
  end

end
