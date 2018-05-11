class HelpsController < ApplicationController

  skip_before_action :authenticate_user!

  def show
    @presenter = HelpPresenter.new
  end
end
