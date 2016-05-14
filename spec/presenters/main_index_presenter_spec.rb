require 'rails_helper'

describe MainIndexPresenter do

  let!(:user) { create_active_user }

  subject { MainIndexPresenter }

  before :each do
    Timecop.freeze(Time.now)
    @presenter = subject.new(user)
  end

  describe '#tournament_finished?' do

    context 'if Tournament.finished? == true' do

      it 'returns true' do
        expect(Tournament).to receive(:finished?).and_return(true)
        expect(@presenter.tournament_finished?).to be true
      end
    end

    context 'if Tournament.finished? == false' do

      it 'returns false' do
        expect(Tournament).to receive(:finished?).and_return(false)
        expect(@presenter.tournament_finished?).to be false
      end
    end
  end

  describe '#get_user_top3_and_own_position' do

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

  describe '#games_presenter' do

    it 'returns GamesPresenter' do
      games_presenter = @presenter.games_presenter
      expect(games_presenter).to be_instance_of GamesPresenter
      expect(games_presenter.current_user).to be(@presenter.current_user)
    end
  end

end