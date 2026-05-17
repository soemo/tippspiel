# frozen_string_literal: true

require 'rails_helper'

describe BonusEditPresenter do
  subject { described_class }

  let!(:team_de) { Team.new(id: 40, country_code: :de, name: 'Germany') }
  let!(:team_cz) { Team.new(id: 50, country_code: :cz, name: 'Czech Republic') }
  let!(:game1) { Game.new(id: 1, team1: team_de, team2: team_cz) }
  let!(:game2) { Game.new(id: 2, team1: team_cz, team2: team_de) }

  let(:user) do
    u = create_active_user
    u.bonus_champion_team = team_de
    u.bonus_second_team = team_cz
    u.bonus_when_final_first_goal = 3
    u.bonus_how_many_goals = 9
    u
  end

  before do
    Timecop.freeze(Time.zone.now)
    game1.start_at = 1.minute.ago
    game2.start_at = 1.minute.from_now
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
        expect(presenter.bonus_champion_team).to be_nil
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
        expect(presenter.bonus_second_team).to be_nil
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
        expect(presenter.bonus_when_final_first_goal).to be_nil
      end
    end
  end

  describe '#bonus_when_final_first_goal_answer' do
    context 'if bonus_when_final_first_goal present' do
      it 'returns selection I18n translation' do
        presenter = subject.new(user)

        expect(presenter.bonus_when_final_first_goal).to eq(3)
        expect(presenter.bonus_when_final_first_goal_answer).to eq('In der Verlängerung')
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
        expect(presenter.bonus_how_many_goals).to be_nil
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
    it 'returns options for select with translated names' do
      expect(TeamQueries).to receive(:all_ordered_by_name).and_return([team_cz, team_de])

      presenter = subject.new(user)
      I18n.with_locale(:de) do
        expect(presenter.options_for_team_tip_select).to eq([
                                                              ['Tschechien', team_cz.id],
                                                              ['Deutschland', team_de.id]
                                                            ])
      end
    end
  end

  describe '#options_for_when_final_first_goal_select' do
    it 'returns options for select' do
      presenter = subject.new(user)
      expect(presenter.options_for_when_final_first_goal_select).to eq([
                                                                         ['In der ersten Halbzeit', 1],
                                                                         ['In der zweiten Halbzeit', 2],
                                                                         ['In der Verlängerung', 3],
                                                                         ['Im Elfmeterschießen', 4]
                                                                       ])
    end
  end

  describe '#round_of_16_name' do
    it 'returns I18n value for Round of 16' do
      presenter = subject.new(user)
      expect(presenter.round_of_16_name).to eq('Achtelfinale')
    end
  end

  describe 'bonus result methods (after final)' do
    let(:winner_team) { create(:team, name: 'Winner') }
    let(:loser_team)  { create(:team, name: 'Loser') }
    let(:final_game) do
      create(:final, team1: loser_team, team2: winner_team,
                     team1_goals: 0, team2_goals: 2, finished: true)
    end

    let(:correct_user) do
      u = create_active_user(create(:user,
                                    bonus_champion_team_id: winner_team.id,
                                    bonus_second_team_id: loser_team.id,
                                    bonus_when_final_first_goal: 2,
                                    bonus_how_many_goals: 7))
      u
    end

    let(:wrong_user) do
      create_active_user(create(:user,
                                bonus_champion_team_id: loser_team.id,
                                bonus_second_team_id: winner_team.id,
                                bonus_when_final_first_goal: 1,
                                bonus_how_many_goals: 3))
    end

    before do
      final_game
      AppSetting.set_bonus_answer_when_will_the_first_goal(2)
      AppSetting.set_bonus_answer_how_many_goals(7)
      allow(Tournament).to receive(:finished?).and_return(true)
    end

    describe '#champion_correct?' do
      it 'returns true when user picked the winning team' do
        expect(described_class.new(correct_user).champion_correct?).to be true
      end

      it 'returns false when user picked the wrong team' do
        expect(described_class.new(wrong_user).champion_correct?).to be false
      end
    end

    describe '#second_correct?' do
      it 'returns true when user picked the losing finalist' do
        expect(described_class.new(correct_user).second_correct?).to be true
      end

      it 'returns false when user picked the wrong team' do
        expect(described_class.new(wrong_user).second_correct?).to be false
      end
    end

    describe '#when_first_goal_correct?' do
      it 'returns true when answer matches AppSetting' do
        expect(described_class.new(correct_user).when_first_goal_correct?).to be true
      end

      it 'returns false when answer does not match' do
        expect(described_class.new(wrong_user).when_first_goal_correct?).to be false
      end

      it 'returns false when AppSetting not set' do
        AppSetting.find_by(key: AppSetting::BONUS_WHEN_FIRST_GOAL_KEY)&.destroy
        expect(described_class.new(correct_user).when_first_goal_correct?).to be false
      end
    end

    describe '#how_many_goals_correct?' do
      it 'returns true when answer matches AppSetting' do
        expect(described_class.new(correct_user).how_many_goals_correct?).to be true
      end

      it 'returns false when answer does not match' do
        expect(described_class.new(wrong_user).how_many_goals_correct?).to be false
      end

      it 'returns false when AppSetting not set' do
        AppSetting.find_by(key: AppSetting::BONUS_HOW_MANY_GOALS_KEY)&.destroy
        expect(described_class.new(correct_user).how_many_goals_correct?).to be false
      end
    end

    describe '#bonus_points' do
      it 'returns the stored bonus_points from the user' do
        correct_user.update_columns(bonus_points: 24)
        expect(described_class.new(correct_user).bonus_points).to eq(24)
      end

      it 'returns 0 when bonus_points is nil' do
        correct_user.update_columns(bonus_points: nil)
        expect(described_class.new(correct_user).bonus_points).to eq(0)
      end
    end
  end
end
