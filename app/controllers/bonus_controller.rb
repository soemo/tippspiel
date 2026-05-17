# frozen_string_literal: true

class BonusController < ApplicationController
  def edit
    @presenter = BonusEditPresenter.new(current_user)
  end
end
