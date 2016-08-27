require 'rails_helper'

describe RankingPerGamesController do

  let!(:games) {
    [Game.new(id: 120, start_at: Time.now - 1.hours),
     Game.new(id: 121, start_at: Time.now - 2.hours)
    ]
  }
  let(:user) { create(:user)}
  let(:current_user) { create :active_user}

  before :each do
    login(current_user)
    expect(GameQueries).to receive(:all_finished_ordered_by_start_at).
        and_return(games)
  end

  describe '#show' do

    it 'calls RankingPerGamesShowPresenter with current_user, params[:id] and return http success' do
      expect(RankingPerGamesShowPresenter).to receive(:new).with(current_user, user.id.to_s, games)

      get :show, id: user.id

      expect(response).to have_http_status(:success)
    end
  end
end
