# frozen_string_literal: true

require 'rails_helper'

describe StatisticsController do
  let!(:games) do
    [Game.new(id: 120, start_at: 1.hour.ago),
     Game.new(id: 121, start_at: 2.hours.ago)]
  end
  let(:user) { create(:user) }
  let(:current_user) { create(:active_user) }

  before do
    login(current_user)
    expect(GameQueries).to receive(:all_finished_ordered_by_start_at)
      .and_return(games)
  end

  describe '#show' do
    it 'calls StatisticsShowPresenter with current_user, params[:id] and return http success' do
      expect(StatisticsShowPresenter).to receive(:new).with(current_user, user.id.to_s, games)

      get :show, params: { id: user.id }

      expect(response).to have_http_status(:ok)
    end
  end
end
