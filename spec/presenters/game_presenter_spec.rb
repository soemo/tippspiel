require 'rails_helper'

describe GamePresenter do

  subject { GamePresenter.new(game) }

  let(:team_de) {Team.new(id: 40, country_code: :de, name: 'Germany')}
  let(:team_cz) {Team.new(id: 50, country_code: :cz, name: 'Czech Republic')}
  let(:game) {
    g = build(:game)
    g.team1_id = 40
    g.team1 = team_de
    g.team1_placeholder_name = 'team1 placholder'
    g.team2_id = 50
    g.team2 = team_cz
    g.team2_placeholder_name = 'team2 placholder'
    g
  }

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
        game.team1_id = nil
        game.team1_placeholder_name = 'Sieger Gruppe A'
        expect(subject.team1_with_flags).to eq 'Sieger Gruppe A'
      end
    end
  end

  describe '#team2_with_flags' do

    context 'if team2_id present' do

      it 'returns team2 name with flag' do
        flag_size = 16
        flag_position = 'right'
        game.team2_id = 2
        team_presenter = TeamPresenter.new(game.team2)
        expect(TeamPresenter).to receive(:new).with(game.team2).and_return(team_presenter)
        expect(team_presenter).to receive(:team_name_with_flag).with(flag_size: flag_size,
                                                                     flag_position: flag_position).
            and_return('team2 name with flag')

        expect(subject.team2_with_flags(flag_size: flag_size,
                                        flag_position: flag_position)).to eq 'team2 name with flag'
      end
    end

    context 'if team2_id not present' do

      it 'returns team2_placeholder_name' do
        game.team2_id = nil
        game.team2_placeholder_name = 'Sieger Gruppe B'
        expect(subject.team2_with_flags).to eq 'Sieger Gruppe B'
      end
    end
  end

  describe '#team_names_with_flags' do

    it 'returns team1 name and team2 name with flag' do
      flag_size = 16
      flag_position = 'right'
      expect(subject).to receive(:team1_with_flags).
          with(flag_size: flag_size,
               flag_position: flag_position).and_return('team 1 name with flag')
      expect(subject).to receive(:team2_with_flags).
          with(flag_size: flag_size,
               flag_position: flag_position).and_return('team 2 name with flag')

      expect(subject.team_names_with_flags(flag_size: flag_size,
                                           team1_flag_position: flag_position,
                                           team2_flag_position: flag_position)).to eq('team 1 name with flag - team 2 name with flag')

    end
  end

  describe '#team_names_without_flags' do

    context 'if team1_id present and team2 id present' do

      it 'returns team1 name and team2 name' do
        expect(subject.team_names_without_flags).to eq("#{game.team1.name} - #{game.team2.name}")
      end
    end

    context 'if team1_id not present and team2_id present' do

      it 'returns team1_placeholder_name and team2 name' do
        game.team1_id = nil
        expect(subject.team_names_without_flags).to eq("#{game.team1_placeholder_name} - #{game.team2.name}")
      end
    end

    context 'if team1_id present and team2_id not present' do

      it 'returns team1 name and team2_placeholder_name' do
        game.team2_id = nil
        expect(subject.team_names_without_flags).to eq("#{game.team1.name} - #{game.team2_placeholder_name}")
      end
    end

    context 'if team1_id and team2_id not present' do

      it 'returns team1_placeholder_name and team2_placeholder_name' do
        game.team1_id = nil
        game.team2_id = nil
        expect(subject.team_names_without_flags).to eq("#{game.team1_placeholder_name} - #{game.team2_placeholder_name}")
      end
    end
  end

  describe '#teams_ordered_by_name' do

    it 'calls TeamQueries all_ordered_by_name' do
      expected = [Team.new(name: 'A'), Team.new(name: 'B'), Team.new(name: 'Z')]
      expect(TeamQueries).to receive(:all_ordered_by_name).and_return(expected)

      expect(subject.teams_ordered_by_name).to eq(expected)
    end
  end
end