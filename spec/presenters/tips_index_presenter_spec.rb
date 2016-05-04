describe TipsIndexPresenter do

  let(:team_de) {Team.new(id: 40, country_code: :de, name: 'Germany')}
  let(:team_cz) {Team.new(id: 50, country_code: :cz, name: 'Czech Republic')}
  let!(:game1) { Game.new(id:1, team1: team_de, team2: team_cz) }
  let!(:game2) { Game.new(id:2, team1: team_cz, team2: team_de) }

  let!(:tip_g1) {Tip.new({id: 400, game: game1}) }
  let!(:tip_g2) {Tip.new({id: 500, game: game2}) }

  let(:user) {User.new(championtip_team: team_de)}

  subject { TipsIndexPresenter }

  before :each do
    Timecop.freeze(Time.now)
    game1.start_at = Time.now - 1.minute
    game2.start_at = Time.now + 1.minute
  end

  describe '#championtip_team' do

    context 'if user present' do

      it 'returns user championtip_team' do
        presenter = subject.new([tip_g1, tip_g2], user)
        expect(presenter.championtip_team).to eq(team_de)
      end
    end

    context 'if user not present' do

      it 'returns nil' do
        presenter = subject.new([tip_g1, tip_g2], nil)
        expect(presenter.championtip_team).to eq(nil)
      end
    end
  end

  describe '#options_for_champion_tip_select' do

    it 'returns options for select' do
      expect(TeamQueries).to receive(:all_ordered_by_name).and_return([team_cz, team_de])

      presenter = subject.new([tip_g1, tip_g2], user)
      expect(presenter.options_for_champion_tip_select).to eq([
                                                                  [team_cz.name, team_cz.id],
                                                                  [team_de.name, team_de.id]
                                                              ])

    end
  end

  describe '#tip_presenters' do

    it 'returns TipPresenters' do
      presenter = subject.new([tip_g1, tip_g2], user)
      tips_presenters = presenter.tip_presenters

      expect(tips_presenters.size).to eq(2)
      expect(tips_presenters[0]).to be_instance_of TipPresenter
      expect(tips_presenters[0].id).to eq 400

      expect(tips_presenters[1]).to be_instance_of TipPresenter
      expect(tips_presenters[1].id).to eq 500
    end
  end
end