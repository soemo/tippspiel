# frozen_string_literal: true

class ImprintsController < ApplicationController
  skip_before_action :authenticate_user!

  def show; end
end
