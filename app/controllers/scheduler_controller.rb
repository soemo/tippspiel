class SchedulerController < ApplicationController

  include CalculatePoints

  MIN_TIME_BETWEEN_RUNS = 5.minutes
  KEEP_SESSION_DAYS     = 7

  before_filter      :check_invoke_frequency, :except => :admin
  skip_before_filter :authenticate_user!

  def hourly
    start_calculate_points
    clean_invoke_table
    render :text => "Hourly scheduler run successful", :status => :ok
  end

  def admin
    start_calculate_points
    render :text => "Admin scheduler run successful", :status => :ok
  end


  private

  def start_calculate_points
    calculate_all_user_tipp_points
    calculate_user_points
  end

  def check_invoke_frequency
    event_type = "scheduler_#{action_name}"
    last_run = Event.last(:order => :created_at, :conditions => {:event_type => event_type})
    if last_run.present? && last_run.created_at > MIN_TIME_BETWEEN_RUNS.ago
      render :text => "scheduler should not run that often", :status => :bad_request
    else
      Event.create! :event_type => event_type
    end
  end

  def clean_invoke_table
    Event.delete_all(["created_at < ?", 1.month.ago.to_s(:db)])
  end

end
