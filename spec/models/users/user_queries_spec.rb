require 'rails_helper'

describe UserQueries do

  subject { UserQueries }

  describe '::all_ordered_by_points_and_all_countxpoints' do

    let(:user1) {create(:user)}
    let(:user2) {create(:active_user,
                        points: 8,
                        count8points: 1,
                        count5points: 0,
                        count4points: 0,
                        count3points: 0)}
    let(:user3) {create(:active_user,
                        points: 8,
                        count8points: 0,
                        count5points: 1,
                        count4points: 0,
                        count3points: 1)}

    let(:user4) {create(:active_user,
                        points: 12,
                        count8points: 0,
                        count5points: 1,
                        count4points: 3,
                        count3points: 0)}
    let(:user5) {create(:active_user,
                        points: 12,
                        count8points: 1,
                        count5points: 0,
                        count4points: 1,
                        count3points: 0)}
    it 'returns active ordered users' do
      expect(subject.all_ordered_by_points_and_all_countxpoints).to eq([
                                                                           user5,
                                                                           user4,
                                                                           user2,
                                                                           user3
                                                                       ])
    end
  end

  describe '::needs_random_tips_for_user_id?' do
    let(:user1) {create(:active_user)}
    let(:user2) {create(:active_user,create_initial_random_tips: true)}

    context 'if user wants random tips' do
      it 'returns true' do
        expect(subject.needs_random_tips_for_user_id?(user2.id)).to be true
      end
    end

    context 'if user does not wants random tips' do
      it 'returns true' do
        expect(subject.needs_random_tips_for_user_id?(user1.id)).to be false
      end
    end
  end

end