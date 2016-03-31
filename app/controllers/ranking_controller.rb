# -*- encoding : utf-8 -*-
class RankingController < ApplicationController

  def index
    @presenter = RankingPresenter.new(current_user: current_user,)
  end
end
