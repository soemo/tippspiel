# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do

  it "should use Factory" do
    user = FactoryGirl.create(:user)
    user.firstname.should == "test"
  end

  it "should not found if inactive" do
      user = FactoryGirl.create(:user)
      User.active.all.should_not include(user)

      User.inactive.all.should include(user)
    end

  it "should check of admin?" do
    user = FactoryGirl.create(:user)
    user.admin?.should be_false
    user.update_attribute(:email, ADMIN_EMAIL)
    user.admin?.should be_true
  end

  describe 'confirm_with_max_time!' do
    it 'should call normal confirmation routine, if confirmation is in time' do
      u = User.new
      u.confirmation_sent_at = 1.hour.ago
      u.should_receive(:confirm_without_maximum_time!).and_return(true)
      u.confirm!
    end

    it 'should add an error, if confirmation is too old' do
      u = User.new
      u.confirmation_sent_at = (User::CONFIRMATION_MAX_TIME + 1.hour).ago
      u.should_not_receive(:confirm_without_maximum_time!)
      u.confirm!
      u.errors[:base].should_not be_empty
    end
  end

  it "should get correct ranking_comparison_value" do
    user1 = FactoryGirl.create(:user,
                    :points=> 46,
                    :count6points=> 3,
                    :count4points=> 7,
                    :count3points=> 0,
                    :count0points=> 10)
    user2 = FactoryGirl.create(:user,
                    :points => 46,
                    :count6points => 1,
                    :count4points => 10,
                    :count3points => 0,
                    :count0points=> 9)
    (user1.ranking_comparison_value > user2.ranking_comparison_value).should be_true
    user1.ranking_comparison_value.should == 46030700
    user2.ranking_comparison_value.should == 46011000
  end


  describe "top3_positions_and_own_position" do
    # FIXME soeren 22.04.12 implement
  end
end
