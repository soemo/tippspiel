# frozen_string_literal: true

module AdaptedDevise
  class ConfirmationsController < Devise::ConfirmationsController
    protected

    # Invalidate the ranking cache when a user confirms their account so the
    # newly active user appears on the ranking list immediately.
    def after_confirmation_path_for(resource_name, resource)
      Rails.cache.delete(RankingPresenter::RANKING_CACHE_KEY)
      super
    end
  end
end
