require 'rails_helper'

RSpec.describe RankingPerGamesController do
  before :each do
    login(create :active_user)
  end

  let(:games) {
    [Game.new(id: 120, start_at: Time.now - 1.hours),
     Game.new(id: 121, start_at: Time.now - 2.hours)
    ]
  }
  let(:usr_ranking) { [1,2]}

  describe '#show' do

    it 'returns http success' do
      expect(GameQueries).to receive(:all_finished_ordered_by_start_at).and_return(games)

      expect(TipQueries).to receive_message_chain(:all_by_user_id_ordered_games_start_at, :pluck).
                                and_return(usr_ranking)
      expect(RankingPerGamesShowPresenter).to receive(:new).with(usr_ranking, games)

      get :show

      expect(response).to have_http_status(:success)
    end
  end
end
