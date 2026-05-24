# frozen_string_literal: true

require 'rails_helper'

describe AdaptedDevise::ConfirmationsController do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe '#after_confirmation_path_for' do
    it 'invalidates the ranking cache when a user confirms their account' do
      # Create an unconfirmed user and capture the raw confirmation token
      # before Devise hashes it — needed to pass as the URL param.
      user = create(:user)
      raw_token, hashed_token = Devise.token_generator.generate(User, :confirmation_token)
      user.update_columns(confirmation_token: hashed_token, confirmed_at: nil)

      expect(Rails.cache).to receive(:delete).with(RankingPresenter::RANKING_CACHE_KEY)

      get :show, params: { confirmation_token: raw_token }
    end
  end
end
