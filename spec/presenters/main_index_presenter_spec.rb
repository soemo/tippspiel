require 'rails_helper'

describe MainIndexPresenter do


  let!(:team_de) {Team.new(id: 40, country_code: :de, name: 'Germany')}
  let!(:team_cz) {Team.new(id: 50, country_code: :cz, name: 'Czech Republic')}
  let!(:game1) { Game.new(id:1, team1: team_de, team2: team_cz) }
  let!(:game2) { Game.new(id:2, team1: team_cz, team2: team_de) }

  let!(:tip_g1) {Tip.new({id: 400, game: game1}) }
  let!(:tip_g2) {Tip.new({id: 500, game: game2}) }

  let(:user) {
    u = create_active_user
    u.bonus_champion_team = team_de
    u
  }

  subject { MainIndexPresenter }

  before :each do
    Timecop.freeze(Time.now)
    game1.start_at = Time.now - 1.minute
    game2.start_at = Time.now + 1.minute
  end

  describe '#tournament_finished?' do

    context 'if Tournament.finished? == true' do

      it 'returns true' do
        presenter = subject.new([tip_g1, tip_g2], user)
        expect(Tournament).to receive(:finished?).and_return(true)
        expect(presenter.tournament_finished?).to be true
      end
    end

    context 'if Tournament.finished? == false' do

      it 'returns false' do
        presenter = subject.new([tip_g1, tip_g2], user)
        expect(Tournament).to receive(:finished?).and_return(false)
        expect(presenter.tournament_finished?).to be false
      end
    end
  end

  describe '#tournament_started?' do

    context 'if Tournament.started? == true' do

      it 'returns true' do
        presenter = subject.new([tip_g1, tip_g2], user)
        expect(Tournament).to receive(:started?).and_return(true)
        expect(presenter.tournament_started?).to be true
      end
    end

    context 'if Tournament.started? == false' do

      it 'returns false' do
        presenter = subject.new([tip_g1, tip_g2], user)
        expect(Tournament).to receive(:started?).and_return(false)
        expect(presenter.tournament_started?).to be false
      end
    end
  end

  describe '#user_name' do

    it 'returns user name' do
      presenter = subject.new([tip_g1, tip_g2], user)
      user.firstname = 'Test'
      user.lastname = 'User'
      expect(presenter.user_name).to eq('Test User')
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