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

  it "should check of admin?" do
    user = FactoryGirl.create(:user)
    expect(user.admin?).to be_falsey
    user.update_attribute(:email, ADMIN_EMAIL)
    expect(user.admin?).to be_truthy
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

  it "should get correct ranking_comparison_value" do
    user1 = FactoryGirl.create(:user,
                    :points=> 46,
                    :count8points=> 3,
                    :count5points=> 4,
                    :count4points=> 7,
                    :count3points=> 0,
                    :count0points=> 10)
    user2 = FactoryGirl.create(:user,
                    :points => 46,
                    :count8points => 1,
                    :count5points => 1,
                    :count4points => 10,
                    :count3points => 0,
                    :count0points=> 9)
    expect(user1.ranking_comparison_value > user2.ranking_comparison_value).to be_truthy
    expect(user1.ranking_comparison_value).to eq(4603040700)
    expect(user2.ranking_comparison_value).to eq(4601011000)
  end

  it 'should delete tipps if user delete' do
    user = FactoryGirl.create(:user)
    5.times{ FactoryGirl.create(:tipp, :user => user) }

    tipp_ids = Tipp.where(:user_id => user.id).pluck(:id)
    expect(tipp_ids.count).to eq(5)

    user.destroy
    expect(Tipp.only_deleted.where(:user_id => user.id).pluck(:id)).to eq(tipp_ids)
  end

end
