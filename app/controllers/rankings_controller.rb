# frozen_string_literal: true

# The ranking list is cached across requests via Rails.cache (key:
# RankingPresenter::RANKING_CACHE_KEY). The cache is invalidated in three places:
#   - Admin::StartCalculatingsController  — manual recalculation from /admin
#   - Results::ImportFinishedGames        — automated background import
#   - AdaptedDevise::ConfirmationsController — new user confirms their account
class RankingsController < ApplicationController
  def index
    @presenter = RankingPresenter.new(current_user)
  end
end
