# frozen_string_literal: true

class HealthChecksController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    ActiveRecord::Base.connection.execute('SELECT 1')
    head :ok
  rescue StandardError
    head :service_unavailable
  end
end
