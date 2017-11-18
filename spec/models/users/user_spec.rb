require 'rails_helper'

describe User, type: :model do

  it 'does not found if inactive' do
      user = FactoryBot.create(:user)
      expect(User.active.to_a).not_to include(user)

      expect(User.inactive.to_a).to include(user)
  end

  describe '#name' do

    it 'returns firstname + lastname' do
      user = User.new(firstname: 'Firstname', lastname: 'Lastname')
      expect(user.name).to eq('Firstname Lastname')
    end
  end

  describe '#admin?' do

    context 'if email == ADMIN_EMAIL' do

      it 'returns true' do
        user = User.new(email: ADMIN_EMAIL)
        expect(user.admin?).to be true
      end
    end


    context  'if email != ADMIN_EMAIL' do

      it 'returns true' do
        user = User.new(email: 'bla@blub.de')
        expect(user.admin?).to be false
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
    user = FactoryBot.create(:user)
    5.times{ FactoryBot.create(:tip, :user => user) }

    tip_ids = Tip.where(:user_id => user.id).pluck(:id)
    expect(tip_ids.count).to eq(5)

    user.destroy
    expect(Tip.only_deleted.where(:user_id => user.id).pluck(:id)).to eq(tip_ids)
  end

end
