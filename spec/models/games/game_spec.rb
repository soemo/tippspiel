require 'rails_helper'

describe Game, :type => :model do

  describe 'validations' do

    it { is_expected.to validate_presence_of(:place) }
    it { is_expected.to validate_presence_of(:round) }
    it { is_expected.to validate_presence_of(:start_at) }

    describe '#started?' do

      context 'if start_at > Time.now' do

        before :each do
          Timecop.freeze
        end

        it 'returns false' do
          game = Game.new(start_at: DateTime.now + 1.second)
          expect(game.started?).to eq(false)
        end
      end

      context 'if start_at <= Time.now' do

        it 'returns true' do
          game = Game.new(start_at: DateTime.now)
          expect(game.started?).to eq(true)

          game = Game.new(start_at: DateTime.now - 1.second)
          expect(game.started?).to eq(true)
        end
      end
    end

    describe '#today?' do

      before :each do
        Timecop.freeze
      end

      context 'if game starts today' do

        it 'returns true' do
          game = Game.new(start_at: Time.now)
          expect(game.today?).to be true
        end
      end

      context 'if game starts not today' do

        it 'returns false' do
          game = Game.new(start_at: Time.now - 1.day)
          expect(game.today?).to be false

          game = Game.new(start_at: Time.now + 1.day)
          expect(game.today?).to be false
        end
      end
    end

    describe 'presence_of_teams' do

      it 'returns valid false' do
        valid_attr = {start_at: '19.06.2012 20:45',
                      place: 'Ort',
                      group: GROUP_D,
                      round: GROUP,
                      team1_id: 1,
                      team2_id: 2}

        game = Game.new(valid_attr.merge({team1_id: nil}))
        game.valid?
        expect(game.errors.messages).to eq({team1_id:
                                                [I18n.t('activerecord.errors.messages.blank')]})

        game = Game.new(valid_attr.merge({team2_id: nil}))
        game.valid?
        expect(game.errors.messages).to eq({team2_id:
                                                [I18n.t('activerecord.errors.messages.blank')]})
      end

      it 'returns valid true' do
        valid_attr = {start_at: '19.06.2012 20:45',
                      place: 'Ort',
                      group: GROUP_D,
                      round: GROUP,
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
end
