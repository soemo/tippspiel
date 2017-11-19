require 'cancan/matchers'

describe Ability do

  subject(:ability){ Ability.new(user) }
  let(:user){ User.new }

  context 'if user present?' do

    it 'can manage its own tips' do
      tip1 = Tip.new(user_id: user.id)
      tip2 = Tip.new(user_id: nil)

      expect(ability.can?(:manage, tip1))
      expect(ability.cannot(:manage, tip2))
    end
  end

  context 'can access' do

    it 'can access main and help' do
      expect(ability.can?(:access, :main)).to be true
      expect(ability.can?(:access, :help)).to be true
    end
  end

  context 'manage games'do

    context 'user is no admin' do

      it{ is_expected.not_to be_able_to(:create, Game.new) }
      it{ is_expected.not_to be_able_to(:read, Game.new) }
      it{ is_expected.not_to be_able_to(:update, Game.new) }
      it{ is_expected.not_to be_able_to(:destroy, Game.new) }
      it{ is_expected.not_to be_able_to(:manage, Game.new) }
    end
  end

  context 'user is an admin' do
    before :each do
      user.email = ADMIN_EMAIL
    end

    it{ is_expected.to be_able_to(:create, Game.new) }
    it{ is_expected.to be_able_to(:read, Game.new) }
    it{ is_expected.to be_able_to(:update, Game.new) }
    it{ is_expected.to be_able_to(:destroy, Game.new) }
    it{ is_expected.to be_able_to(:manage, Game.new) }
  end
end
