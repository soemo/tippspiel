# -*- encoding : utf-8 -*-
class RankingController < ApplicationController

  def index
    @presenter = RankingPresenter.new
  end
end
