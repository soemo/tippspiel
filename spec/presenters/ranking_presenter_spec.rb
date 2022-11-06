require 'rails_helper'

describe RankingPresenter do

  subject { RankingPresenter.new }

  describe '#bonus_answers_visible?' do
    context 'if Tournament.round_of_16_started? == true' do
      it 'returns true' do
        expect(Tournament).to receive(:round_of_16_started?).and_return(true)
        expect(subject.bonus_answers_visible?).to be true
      end
    end

    context 'if Tournament.round_of_16_started? == false' do
      it 'returns false' do
        expect(Tournament).to receive(:round_of_16_started?).and_return(false)
        expect(subject.bonus_answers_visible?).to be false
      end
    end
  end

  describe '#bonus_answers_visible?' do
    it 'calls GameQueries finished' do
      expected = [Game.new, Game.new]
      expect(GameQueries).to receive(:finished).and_return(expected)
      expect(expected).to receive(:count).and_return(2)

      expect(subject.finished_games_count).to eq(2)
    end
  end

  describe '#finished_games_count' do

    it 'calls GameQueries finished' do
      expected = [Game.new, Game.new]
      expect(GameQueries).to receive(:finished).and_return(expected)
      expect(expected).to receive(:count).and_return(2)

      expect(subject.finished_games_count).to eq(2)
    end
  end

  describe '#all_games_count' do

    it 'returns game count' do
      expect(Game).to receive(:count).and_return(3)

      expect(subject.all_games_count).to eq(3)
    end
  end

  describe '#user_count' do

    it 'returns user count' do
      expected = [User.new, User.new]
      expect(User).to receive(:active).and_return(expected)
      expect(expected).to receive(:count).and_return(2)

      expect(subject.user_count).to eq(2)
    end
  end

  describe '#user_ranking_hash' do

    it 'returns sorted user_ranking_hash' do
      user1 = User.new(points: 4)
      user2 = User.new(points: 10)
      user3 = User.new(points: 8)
      user4 = User.new(points: 12)
      query_result = [user4, user2, user3, user1]

      expect(UserQueries).to receive(:all_ordered_by_points_and_all_countxpoints).
          and_return(query_result)

      expected = {
          1 => [user4],
          2 => [user2],
          3 => [user3],
          4 => [user1]
      }

      expect(Users::PrepareRanking).to receive(:call).
          with(users_for_ranking: query_result).
          and_return(expected)

      expect(subject.user_ranking_hash).to eq([[1, [user4]],
                                               [2, [user2]],
                                               [3, [user3]],
                                               [4, [user1]],
                                              ])
    end
  end
end
