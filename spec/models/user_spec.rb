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
    (user1.ranking_comparison_value > user2.ranking_comparison_value).should be_true
    user1.ranking_comparison_value.should == 4603040700
    user2.ranking_comparison_value.should == 4601011000
  end

  it 'should delete tipps if user delete' do
    user = FactoryGirl.create(:user)
    5.times{ FactoryGirl.create(:tipp, :user => user) }

    tipps = Tipp.where(:user_id => user.id).all
    tipps.count.should == 5

    user.destroy
    Tipp.only_deleted.where(:user_id => user.id).map(&:id).should == tipps.map(&:id)
  end

  it 'should get top3_positions_and_own_position' do
    User.delete_all # fixture users delete
    user_top3_ranking_hash, own_position = User.top3_positions_and_own_position(nil)
    own_position.should == nil
    user_top3_ranking_hash.should == {}

    # 10 User anlegen, alle auf der selben Platzierung
    user_size = 10
    points    = 13
    user_size.times do |index|
      FactoryGirl.create(:user,
                        :lastname => "user#{index}",
                        :points => points,
                        :confirmed_at => Time.now - 5.minutes)
    end

    last_db_user = User.last
    user_top3_ranking_hash, own_position = User.top3_positions_and_own_position(last_db_user.id)
    own_position.should == 1
    user_top3_ranking_hash.size.should == 1
    user_top3_ranking_hash[1].size.should == User.count

    user_top3_ranking_hash, own_position = User.top3_positions_and_own_position(nil)
    own_position.should == nil
    user_top3_ranking_hash.size.should == 1
    user_top3_ranking_hash[1].size.should == User.count
  end
end
