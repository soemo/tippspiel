require 'rails_helper'

describe BonusEditPresenter do

  let!(:team_de) {Team.new(id: 40, country_code: :de, name: 'Germany')}
  let!(:team_cz) {Team.new(id: 50, country_code: :cz, name: 'Czech Republic')}
  let!(:game1) { Game.new(id:1, team1: team_de, team2: team_cz) }
  let!(:game2) { Game.new(id:2, team1: team_cz, team2: team_de) }

  let(:user) {
    u = create_active_user
    u.bonus_champion_team = team_de
    u.bonus_second_team = team_cz
    u.bonus_when_final_first_goal = 3
    u.bonus_how_many_goals = 9
    u
  }

  subject { BonusEditPresenter }

  before :each do
    Timecop.freeze(Time.now)
    game1.start_at = Time.now - 1.minute
    game2.start_at = Time.now + 1.minute
  end

  describe '#round_of_16_started?' do
    context 'if Tournament.round_of_16_started? == true' do
      it 'returns true' do
        presenter = subject.new(user)
        expect(Tournament).to receive(:round_of_16_started?).and_return(true)
        expect(presenter.round_of_16_started?).to be true
      end
    end

    context 'if Tournament.round_of_16_started? == false' do
      it 'returns false' do
        presenter = subject.new(user)
        expect(Tournament).to receive(:round_of_16_started?).and_return(false)
        expect(presenter.round_of_16_started?).to be false
      end
    end
  end

  describe '#bonus_champion_team' do
    context 'if user present' do
      it 'returns user bonus_champion_team' do
        presenter = subject.new(user)
        expect(presenter.bonus_champion_team).to eq(team_de)
      end
    end

    context 'if user not present' do
      it 'returns nil' do
        presenter = subject.new(nil)
        expect(presenter.bonus_champion_team).to eq(nil)
      end
    end
  end

  describe '#bonus_champion_team_id' do
    context 'if bonus_champion_team present' do
      it 'returns User bonus_champion_team_id' do
        presenter = subject.new(user)
        expect(presenter.bonus_champion_team_id).to eq(team_de.id)
      end
    end

    context 'if user not present' do
      it 'returns nil' do
        presenter = subject.new(nil)
        expect(presenter.bonus_champion_team_id).to eq('')
      end
    end
  end

  describe '#champion_team_with_flag' do
    context 'if bonus_champion_team present' do
      it 'calls TeamPresenter method champion_team_with_flag' do
        team_presenter = TeamPresenter.new(team_de)

        presenter = subject.new(user)
        expect(presenter).to receive(:bonus_champion_team).and_return(team_de)
        expect(TeamPresenter).to receive(:new).with(team_de).and_return(team_presenter)

        presenter.champion_team_with_flag
      end
    end

    context 'if bonus_champion_team not present' do
      it 'returns does not call TeamPresenter' do
        presenter = subject.new(user)
        expect(presenter).to receive(:bonus_champion_team).and_return(nil)
        expect(TeamPresenter).not_to receive(:new)

        expect(presenter.champion_team_with_flag).to eq(I18n.t('no_champion_tip'))
      end
    end
  end

  describe '#bonus_second_team' do
    context 'if user present' do
      it 'returns user bonus_second_team' do
        presenter = subject.new(user)
        expect(presenter.bonus_second_team).to eq(team_cz)
      end
    end

    context 'if user not present' do
      it 'returns nil' do
        presenter = subject.new(nil)
        expect(presenter.bonus_second_team).to eq(nil)
      end
    end
  end

  describe '#bonus_second_team_id' do
    context 'if bonus_second_team present' do
      it 'returns User bonus_second_team_id' do
        presenter = subject.new(user)
        expect(presenter.bonus_second_team_id).to eq(team_cz.id)
      end
    end

    context 'if user not present' do
      it 'returns nil' do
        presenter = subject.new(nil)
        expect(presenter.bonus_second_team_id).to eq('')
      end
    end
  end

  describe '#second_team_with_flag' do
    context 'if bonus_second_team present' do
      it 'calls TeamPresenter method second_team_with_flag' do
        team_presenter = TeamPresenter.new(team_cz)

        presenter = subject.new(user)
        expect(presenter).to receive(:bonus_second_team).and_return(team_cz)
        expect(TeamPresenter).to receive(:new).with(team_cz).and_return(team_presenter)

        presenter.second_team_with_flag
      end
    end

    context 'if bonus_second_team not present' do
      it 'returns does not call TeamPresenter' do
        presenter = subject.new(user)
        expect(presenter).to receive(:bonus_second_team).and_return(nil)
        expect(TeamPresenter).not_to receive(:new)

        expect(presenter.second_team_with_flag).to eq(I18n.t('no_second_tip'))
      end
    end
  end

  describe '#bonus_when_final_first_goal' do
    context 'if user present' do
      it 'returns user bonus_when_final_first_goal' do
        presenter = subject.new(user)
        expect(presenter.bonus_when_final_first_goal).to eq(3)
      end
    end

    context 'if user not present' do
      it 'returns nil' do
        presenter = subject.new(nil)
        expect(presenter.bonus_when_final_first_goal).to eq(nil)
      end
    end
  end

  describe '#bonus_when_final_first_goal_answer' do
    context 'if bonus_when_final_first_goal present' do
      it 'returns selection I18n translation' do
        presenter = subject.new(user)

        expect(presenter.bonus_when_final_first_goal).to eq(3)
        expect(presenter.bonus_when_final_first_goal_answer).to eq("In der Verlängerung")
      end
    end

    context 'if bonus_when_final_first_goal not present' do
      it 'returns not answered bonus question' do
        presenter = subject.new(user)
        expect(presenter).to receive(:bonus_when_final_first_goal).and_return(nil)

        expect(presenter.bonus_when_final_first_goal_answer).to eq(I18n.t('no_when_first_goal_tip'))
      end
    end
  end

  describe '#bonus_how_many_goals' do
    context 'if user present' do
      it 'returns user bonus_how_many_goals' do
        presenter = subject.new(user)
        expect(presenter.bonus_how_many_goals).to eq(9)
      end
    end

    context 'if user not present' do
      it 'returns nil' do
        presenter = subject.new(nil)
        expect(presenter.bonus_how_many_goals).to eq(nil)
      end
    end
  end

  describe '#bonus_how_many_goals_answer' do
    context 'if bonus_how_many_goals present' do
      it 'returns bonus_how_many_goals' do
        presenter = subject.new(user)

        expect(presenter.bonus_how_many_goals).to eq(9)
        expect(presenter.bonus_how_many_goals_answer).to eq(9)
      end
    end

    context 'if bonus_how_many_goals not present' do
      it 'returns not answered bonus question' do
        presenter = subject.new(user)
        expect(presenter).to receive(:bonus_how_many_goals).and_return(nil)

        expect(presenter.bonus_how_many_goals_answer).to eq(I18n.t('no_how_many_goals_tip'))
      end
    end
  end

  describe '#options_for_team_tip_select' do
    it 'returns options for select' do
      expect(TeamQueries).to receive(:all_ordered_by_name).and_return([team_cz, team_de])

      presenter = subject.new(user)
      expect(presenter.options_for_team_tip_select).to eq([
                                                            [team_cz.name, team_cz.id],
                                                            [team_de.name, team_de.id]
                                                          ])
    end
  end

  describe '#options_for_when_final_first_goal_select' do
    it 'returns options for select' do
      presenter = subject.new(user)
      expect(presenter.options_for_when_final_first_goal_select).to eq([
                                                                         ["In der ersten Halbzeit", 1],
                                                                         ["In der zweiten Halbzeit", 2],
                                                                         ["In der Verlängerung", 3],
                                                                         ["Im Elfmeterschießen", 4]
                                                                       ])
    end
  end

  describe '#round_of_16_name' do
    it 'returns I18n value' do
      presenter = subject.new(user)
      expect(presenter.round_of_16_name).to eq('Achtelfinale')
    end
  end
end