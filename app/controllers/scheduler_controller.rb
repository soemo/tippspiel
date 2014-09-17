# -*- encoding : utf-8 -*-
class SchedulerController < ApplicationController

  include CalculatePoints     # FIXME soeren 06.09.2014 #81 Service?
  include ResultGrabber       # FIXME soeren 06.09.2014 #81 Service?
  include RssReader           # FIXME soeren 06.09.2014 #81 Service?

  MIN_TIME_BETWEEN_RUNS = 5.minutes

  before_filter      :check_invoke_frequency, :except => :admin
  skip_before_filter :authenticate_user!

  def hourly
    start_calculate_points
    clean_invoke_table
    write_rss_feed_cache_xml_file(RSS_FEED_URL)
    render :plain => "Hourly scheduler run successful", :status => :ok
  end

  def admin
    start_calculate_points
    render :plain => "Admin scheduler run successful", :status => :ok
  end


  private

  def start_calculate_points
    update_games
    calculate_all_user_tipp_points
    calculate_user_points
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
