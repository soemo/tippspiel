# frozen_string_literal: true

module Rankings
  # Recalculates tip points, user points and per-game ranking places in a single
  # transaction. Called from both the admin UI and the automated game import.
  #
  # After the transaction completes, the cached ranking hash is invalidated so
  # the next request to RankingsController#index recomputes from fresh DB data.
  class Recalculate < BaseService
    def call
      ActiveRecord::Base.transaction do
        ::Tips::UpdatePoints.call
        ::Users::UpdatePoints.call
        ::Users::UpdateRankingPerGame.call
      end

      Rails.cache.delete(RankingPresenter::RANKING_CACHE_KEY)
    end
  end
end
