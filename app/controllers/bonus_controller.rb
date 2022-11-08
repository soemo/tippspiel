# -*- encoding : utf-8 -*-
class BonusController < ApplicationController

  def edit
    @presenter = BonusEditPresenter.new(current_user)
  end

end