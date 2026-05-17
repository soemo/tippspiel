# frozen_string_literal: true

class RankingsController < ApplicationController
  def index
    @presenter = RankingPresenter.new
  end
end
