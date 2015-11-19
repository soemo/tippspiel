require 'rails_helper'

RSpec.describe RankingPerGameController do
  spec_login_user

  let(:games) {[Game.new(id:120, start_at: Time.now),
                Game.new(id: 121,  start_at: Time.now)]}

  describe '#show' do
    it "returns http success" do
      expect(GameQueries).to receive(:all_finished_ordered_by_start_at).and_return(games)

      expect(TipQueries).to receive_message_chain(:all_by_user_id_and_game_ids, :pluck).
                                and_return([1,2])

      get :show


      expect(response).to have_http_status(:success)
    end
  end
end
