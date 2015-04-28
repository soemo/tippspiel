describe TippsComparePresenter do

  let!(:game1) { Game.new }
  let!(:game2) { Game.new }

  let!(:tipp_g1) {Tipp.new({game: game1}) }
  let!(:tipp_g2) {Tipp.new({game: game2}) }

  subject { TippsComparePresenter }

  before :each do
    Timecop.freeze(Time.now)
    game1.start_at = Time.now - 1.minute
    game2.start_at = Time.now + 1.minute

    @presenter = subject.new([game1, game2], game1, [tipp_g1, tipp_g2])
  end

  describe '#allowed_to_show?' do

    it 'returns true if tipp.game has started' do
      expect(@presenter.allowed_to_show?(tipp_g1)).to be true
    end

    it 'returns false if tipp.game has not started' do
      expect(@presenter.allowed_to_show?(tipp_g2)).to be false
    end

  end

end