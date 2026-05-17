# frozen_string_literal: true

class RankingsController < ApplicationController
  def index
    @presenter = RankingPresenter.new(current_user)
  end
end
