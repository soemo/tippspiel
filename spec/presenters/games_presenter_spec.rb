describe GamesPresenter do

  subject { GamesPresenter.new(current_user) }

  let(:current_user) { User.new }
  let(:games) { [Game.new(id:2), Game.new(id: 1), Game.new(id:3)] }

  describe '#games' do

    it 'returns all games ordered by start_at' do
      expect(GameQueries).to receive(:all_ordered_by_start_at).
          and_return(games)

      expect(subject.games).to eq(games)
    end
  end

  describe '#game_presenters' do

    it 'returns GamePresenters' do
      expect(GameQueries).to receive(:all_ordered_by_start_at).
          and_return(games)

      game_presenters = subject.game_presenters

      expect(game_presenters.size).to eq(3)
      expect(game_presenters[0]).to be_instance_of GamePresenter
      expect(game_presenters[0].id).to eq 2

      expect(game_presenters[1]).to be_instance_of GamePresenter
      expect(game_presenters[1].id).to eq 1

      expect(game_presenters[2]).to be_instance_of GamePresenter
      expect(game_presenters[2].id).to eq 3
    end
  end
end