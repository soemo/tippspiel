# frozen_string_literal: true

require 'rails_helper'

describe User do
  describe 'association' do
    it { is_expected.to belong_to(:bonus_champion_team).class_name('Team').optional }
    it { is_expected.to have_many(:tips).dependent(:destroy) }
  end

  context 'validation' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).scoped_to([:deleted_at]).ignoring_case_sensitivity }
    it { is_expected.to validate_presence_of(:firstname) }
    it { is_expected.to validate_presence_of(:lastname) }

    describe 'email confirmation' do
      it 'is valid when email and email_confirmation match' do
        user = build(:user, email: 'foo@example.com', email_confirmation: 'foo@example.com')
        user.valid?
        expect(user.errors[:email_confirmation]).to be_empty
      end

      it 'is invalid when email_confirmation does not match email' do
        user = build(:user, email: 'foo@example.com', email_confirmation: 'bar@example.com')
        expect(user).not_to be_valid
        expect(user.errors[:email_confirmation]).not_to be_empty
      end

      it 'is invalid when email_confirmation is blank on a new record' do
        user = build(:user, email: 'foo@example.com', email_confirmation: '')
        expect(user).not_to be_valid
        expect(user.errors[:email_confirmation]).not_to be_empty
      end
    end

    describe 'name fields must not contain email' do
      it 'is invalid when firstname looks like an email address' do
        user = build(:user, firstname: 'foo@example.com')
        expect(user).not_to be_valid
        expect(user.errors[:firstname]).not_to be_empty
      end

      it 'is invalid when lastname looks like an email address' do
        user = build(:user, lastname: 'foo@example.com')
        expect(user).not_to be_valid
        expect(user.errors[:lastname]).not_to be_empty
      end

      it 'is valid when firstname and lastname are plain names' do
        user = build(:user, firstname: 'Max', lastname: 'Mustermann')
        user.valid?
        expect(user.errors[:firstname]).to be_empty
        expect(user.errors[:lastname]).to be_empty
      end
    end
  end

  it 'does not found if inactive' do
    user = create(:user)
    expect(described_class.active.to_a).not_to include(user)
    expect(described_class.inactive.to_a).to include(user)
  end

  it 'create_initial_random_tips is default false' do
    user = create(:user)
    expect(user.create_initial_random_tips?).to be(false)
  end

  describe '#name' do
    it 'returns firstname + lastname' do
      user = described_class.new(firstname: 'Firstname', lastname: 'Lastname')
      expect(user.name).to eq('Firstname Lastname')
    end
  end

  describe '#admin?' do
    context 'if email == ADMIN_EMAIL' do
      it 'returns true' do
        user = described_class.new(email: ADMIN_EMAIL)
        expect(user.admin?).to be true
      end
    end

    context 'if email != ADMIN_EMAIL' do
      it 'returns true' do
        user = described_class.new(email: 'bla@blub.de')
        expect(user.admin?).to be false
      end
    end
  end

  describe '#all_bonus_questions_filled_out?' do
    context 'if all question filled out' do
      it 'returns true' do
        user = described_class.new(
          bonus_champion_team_id: 1,
          bonus_second_team_id: 2,
          bonus_when_final_first_goal: 4,
          bonus_how_many_goals: 9
        )
        expect(user.all_bonus_questions_filled_out?).to be true
      end
    end

    context 'if not all question filled out' do
      it 'returns false' do
        user = described_class.new(
          bonus_champion_team_id: nil,
          bonus_second_team_id: nil,
          bonus_when_final_first_goal: nil,
          bonus_how_many_goals: nil
        )
        expect(user.all_bonus_questions_filled_out?).to be false
        user.bonus_champion_team_id = 1
        expect(user.all_bonus_questions_filled_out?).to be false
        user.bonus_second_team_id = 2
        expect(user.all_bonus_questions_filled_out?).to be false
        user.bonus_when_final_first_goal = 4
        expect(user.all_bonus_questions_filled_out?).to be false
      end
    end
  end

  describe 'confirm' do
    it 'adds an error, if confirmation is too old' do
      u = create(:user)
      u.update_column(:confirmation_sent_at, (7.days + 1.hour).ago)
      u.confirm

      expect(u.errors[:email]).to eq([I18n.t('errors.messages.confirmation_period_expired', period: '7 Tage')])
    end
  end

  it 'deletes tips if user delete' do
    user = create(:user)
    create_list(:tip, 5, user: user)

    tip_ids = Tip.where(user_id: user.id).pluck(:id)
    expect(tip_ids.count).to eq(5)

    user.destroy
    expect(Tip.only_deleted.where(user_id: user.id).pluck(:id)).to eq(tip_ids)
  end
end
