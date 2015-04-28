require 'rails_helper'

describe MainIndexPresenter do

  let!(:user) { create_active_user }

  subject { MainIndexPresenter }

  before :each do
    Timecop.freeze(Time.now)
    @presenter = subject.new(user)
  end

  context '#today_games' do

    it 'returns no games if no game available' do
      expect(@presenter.today_games).to eq([])
    end

    it 'returns today game' do
      game1 = create(:game, start_at: Date.today.midnight - 1.second)
      game2 = create(:game, start_at: Date.today.midnight)
      game3 = create(:game, start_at: Time.now)
      game4 = create(:game, start_at: Date.tomorrow.midnight - 1.second)
      game5 = create(:game, start_at: Date.tomorrow.midnight)
      game6 = create(:game, start_at: Date.tomorrow.midnight + 1.second)

      expect(@presenter.today_games.to_a).to eq([game2, game3, game4, game5])
    end

  end

  context '#get_user_top3_and_own_position' do
    it 'returns both one if only one user is available' do
      result = @presenter.get_user_top3_and_own_position
      expect(result.own_position).to eq(1)
      expect(result.user_top3_ranking_hash).to eq({1 => [user]})
    end

    it 'returns position 3 for user' do
      u1 = create_active_user
      u1.update_column(:points, 10)

      u2 = create_active_user
      u2.update_column(:points, 8)

      # eigener nutzer
      user.update_column(:points, 2)

      result = @presenter.get_user_top3_and_own_position
      expect(result.own_position).to eq(3)
      expect(result.user_top3_ranking_hash).to eq({1 => [u1],
                                                   2 => [u2],
                                                   3 => [user]})
    end

  end

end