require 'rails_helper'

describe TipsComparePresenter do

  let(:team_de) {Team.new(id: 40, country_code: :de, name: 'Germany')}
  let(:team_cz) {Team.new(id: 50, country_code: :cz, name: 'Czech Republic')}
  let!(:game1) { Game.new(id:1,
                          team1_id: 40, team1: team_de,
                          team2_id: 50, team2: team_cz) }
  let!(:game2) { Game.new(id:2,
                          team1_id: 50, team1: team_cz,
                          team2_id: 40, team2: team_de) }

  let!(:tip_g1) {Tip.new({game: game1}) }
  let!(:tip_g2) {Tip.new({game: game2}) }

  subject { TipsComparePresenter }

  before :each do
    Timecop.freeze(Time.now)
    game1.start_at = Time.now - 1.minute
    game2.start_at = Time.now + 1.minute

    @presenter = subject.new([game1, game2], game1, [tip_g1, tip_g2])
  end

  describe '#game_to_compare_presenter' do

    it 'returns GamePresenter' do
      game_presenter = @presenter.game_to_compare_presenter
      expect(game_presenter).to be_a GamePresenter
      expect(game_presenter.id).to eq(1)
    end

  end

  describe '#allowed_to_show?' do

    it 'returns true if tip.game has started' do
      expect(@presenter.allowed_to_show?(tip_g1)).to be true
    end

    it 'returns false if tip.game has not started' do
      expect(@presenter.allowed_to_show?(tip_g2)).to be false
    end
  end

  describe 'options_for_select' do

    it 'returns options for tip copare select' do

      option1 = ["#{I18n.l(game1.start_at, format: :default)} #{game1.team1.name} - #{game1.team2.name}", game1.id]
      option2 = ["#{I18n.l(game2.start_at, format: :default)} #{game2.team1.name} - #{game2.team2.name}", game2.id]

      expect(@presenter.options_for_select).to eq([option1, option2])
    end
  end
end