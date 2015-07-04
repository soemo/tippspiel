describe TipsComparePresenter do

  let!(:game1) { Game.new }
  let!(:game2) { Game.new }

  let!(:tip_g1) {Tip.new({game: game1}) }
  let!(:tip_g2) {Tip.new({game: game2}) }

  subject { TipsComparePresenter }

  before :each do
    Timecop.freeze(Time.now)
    game1.start_at = Time.now - 1.minute
    game2.start_at = Time.now + 1.minute

    @presenter = subject.new([game1, game2], game1, [tip_g1, tip_g2])
  end

  describe '#allowed_to_show?' do

    it 'returns true if tip.game has started' do
      expect(@presenter.allowed_to_show?(tip_g1)).to be true
    end

    it 'returns false if tip.game has not started' do
      expect(@presenter.allowed_to_show?(tip_g2)).to be false
    end

  end

end