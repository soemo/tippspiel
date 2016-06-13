# -*- encoding : utf-8 -*-
require 'rails_helper'

describe User, :type => :model do

  it "should use Factory" do
    user = FactoryGirl.create(:user)
    expect(user.firstname).to eq("test")
  end

  it "should not found if inactive" do
      user = FactoryGirl.create(:user)
      expect(User.active.to_a).not_to include(user)

      expect(User.inactive.to_a).to include(user)
    end

  it 'admin?' do
    user = FactoryGirl.create(:user)
    expect(user.admin?).to be false
    user.update_attribute(:email, ADMIN_EMAIL)
    expect(user.admin?).to be true
  end

  describe 'confirm_with_max_time!' do
    it 'should call normal confirmation routine, if confirmation is in time' do
      u = User.new
      u.confirmation_sent_at = 1.hour.ago
      expect(u).to receive(:confirm_without_maximum_time!).and_return(true)
      u.confirm!
    end

    it 'should add an error, if confirmation is too old' do
      u = User.new
      u.confirmation_sent_at = (User::CONFIRMATION_MAX_TIME + 1.hour).ago
      expect(u).not_to receive(:confirm_without_maximum_time!)
      u.confirm!
      expect(u.errors[:base]).not_to be_empty
    end
  end

  it 'should delete tips if user delete' do
    user = FactoryGirl.create(:user)
    5.times{ FactoryGirl.create(:tip, :user => user) }

    tip_ids = Tip.where(:user_id => user.id).pluck(:id)
    expect(tip_ids.count).to eq(5)

    user.destroy
    expect(Tip.only_deleted.where(:user_id => user.id).pluck(:id)).to eq(tip_ids)
  end

end
