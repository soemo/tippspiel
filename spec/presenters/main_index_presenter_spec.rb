require 'rails_helper'

describe MainIndexPresenter do

  let!(:user) { create_active_user }

  subject { MainIndexPresenter }

  before :each do
    Timecop.freeze(Time.now)
    @presenter = subject.new(user)
  end

  describe '#tournament_started?' do

    it 'calls Tournament.started?' do
      expect(Tournament).to receive(:started?)
      @presenter.tournament_started?
    end
  end

  describe '#tournament_finished?' do

    it 'calls Tournament.finished?' do
      expect(Tournament).to receive(:finished?)
      @presenter.tournament_finished?
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

end