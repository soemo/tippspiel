require 'rails_helper'

describe Game, :type => :model do

  describe 'validations' do

    it { is_expected.to validate_presence_of(:place) }
    it { is_expected.to validate_presence_of(:round) }
    it { is_expected.to validate_presence_of(:start_at) }
    it { is_expected.to validate_presence_of(:api_match_id) }
    it { is_expected.to validate_uniqueness_of(:api_match_id) }

    describe 'presence_of_teams' do

      it 'returns valid false' do
        valid_attr = {start_at: '19.06.2012 20:45',
                      place: 'Ort',
                      group: GROUP_D,
                      round: GROUP,
                      api_match_id: 1,
                      team1_id: 1,
                      team2_id: 2}

        game = Game.new(valid_attr.merge({team1_id: nil}))
        game.valid?
        expect(game.errors.messages).to eq({team1:
                                                [I18n.t('activerecord.errors.messages.blank')]})

        game = Game.new(valid_attr.merge({team2_id: nil}))
        game.valid?
        expect(game.errors.messages).to eq({team2:
                                                [I18n.t('activerecord.errors.messages.blank')]})
      end

      it 'returns valid true' do
        valid_attr = {start_at: '19.06.2012 20:45',
                      place: 'Ort',
                      group: GROUP_D,
                      round: GROUP,
                      api_match_id: 1,
                      team1_id: 1,
                      team2_id: 2}

        game = Game.new(valid_attr)
        game.valid?
        expect(game.errors.messages).to eq({})

        game = Game.new(valid_attr.merge({team1_id: nil, team1_placeholder_name: 'Blah'}))
        game.valid?
        expect(game.errors.messages).to eq({})

        game = Game.new(valid_attr.merge({team2_id: nil, team2_placeholder_name: 'Blah'}))
        game.valid?
        expect(game.errors.messages).to eq({})
      end
    end
  end

  describe '#to_s' do

    it 'shows startdate with the two team names' do
      team1 = Team.new(name: 'Holzbein Kiel')
      team2 = Team.new(name: 'Dynamo Dresden')
      start_time = Time.now
      game = Game.new({team1: team1, team2:team2, start_at: start_time})

      expect(game.to_s).to eq("#{I18n.l(start_time, :format => :default)}:  #{team1.name} - #{team2.name}")
    end
  end

  describe '#team1_view_name' do
    let(:team) {Team.new(name: 'Dynamo Dresden')}
    let(:game) {Game.new({team1_placeholder_name: 'blah'})}

    context 'if no team1 present' do

      it 'shows team1_placeholder_name' do
        expect(game.team1_view_name).to eq('blah')
      end

      context 'if team present' do

        it 'shows team1 name' do
          game.team1 = team

          expect(game.team1_view_name).to eq('Dynamo Dresden')
        end
      end
    end
  end

  describe '#team2_view_name' do
    let(:team) {Team.new(name: 'Dynamo Dresden')}
    let(:game) {Game.new({team2_placeholder_name: 'blub'})}

    context 'if no team2 present' do

      it 'shows team2_placeholder_name' do
        expect(game.team2_view_name).to eq('blub')
      end

      context 'if team present' do

        it 'shows team2 name' do
          game.team2 = team

          expect(game.team2_view_name).to eq('Dynamo Dresden')
        end
      end
    end
  end

  describe '#team1_country_code' do
    let(:team) {Team.new(country_code: :de)}
    let(:game) {Game.new}

    context 'if no team1 present' do

      it 'shows empty string' do
        expect(game.team1_country_code).to eq('')
      end

      context 'if team1 present' do

        it 'shows team1 country_code' do
          game.team1 = team

          expect(game.team1_country_code).to eq('de')
        end
      end
    end
  end

  describe '#team2_country_code' do
    let(:team) {Team.new(country_code: :de)}
    let(:game) {Game.new}

    context 'if no team2 present' do

      it 'shows empty string' do
        expect(game.team2_country_code).to eq('')
      end

      context 'if team2 present' do

        it 'shows team2 country_code' do
          game.team2 = team

          expect(game.team2_country_code).to eq('de')
        end
      end
    end
  end

end
