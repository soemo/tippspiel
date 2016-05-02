require 'rails_helper'

describe GamePresenter do

  subject { GamePresenter.new(game) }

  let(:game) { build(:game) }

  it { is_expected.to respond_to(:game) }

  it 'delegates all method calls to game by default' do
    game.team1_placeholder_name = 'Sieger Gruppe A'
    expect(subject.team1_placeholder_name).to eq 'Sieger Gruppe A'
  end

  describe '#formatted_start_at' do

    it 'returns formatted_start_at updated_at' do
      Timecop.freeze
      expect(subject.formatted_start_at).to eq I18n.l(game.start_at, format: :default)
    end
  end

  describe '#formatted_start_at_short' do

    it 'returns formatted_start_at updated_at' do
      Timecop.freeze
      expect(subject.formatted_start_at_short).to eq I18n.l(game.start_at, format: :short)
    end
  end

  describe '#round_or_group_name' do

    it 'returns group name if round is GROUP' do
      game.round = GROUP
      expect(subject.round_or_group_name).to eq "#{I18n.t('round.group')} #{game.group}"
    end

    it 'returns round name if round is not GROUP' do
      game.round = SEMIFINAL
      expect(subject.round_or_group_name).to eq I18n.t(game.round, scope: 'round')
    end
  end

  describe '#result' do

    it 'returns game result' do
      game.team1_goals = 4
      game.team2_goals = 3
      expect(subject.result).to eq '4 : 3'
    end
  end

  describe '#team1_with_flags' do

    context 'if team1_id present' do

      it 'returns team1 name with flag' do
        flag_size = 16
        flag_position = 'right'
        game.team1_id = 1
        team_presenter = TeamPresenter.new(game.team1)
        expect(TeamPresenter).to receive(:new).with(game.team1).and_return(team_presenter)
        expect(team_presenter).to receive(:team_name_with_flag).with(flag_size: flag_size,
                                                                     flag_position: flag_position).
            and_return('team name with flag')

        expect(subject.team1_with_flags(flag_size: flag_size,
                                        flag_position: flag_position)).to eq 'team name with flag'
      end
    end

    context 'if team1_id not present' do

      it 'returns team1_placeholder_name' do
        game.team1_placeholder_name = 'Sieger Gruppe A'
        expect(subject.team1_with_flags).to eq 'Sieger Gruppe A'
      end
    end
  end
end