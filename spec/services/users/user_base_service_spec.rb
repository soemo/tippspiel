require 'rails_helper'

describe Users::UserBaseService do

  subject { Users::UserBaseService.new }

  it 'gets correct ranking_comparison_value' do

    user1 = User.new(:points=> 46,
                     :count8points=> 3,
                     :count5points=> 4,
                     :count4points=> 7,
                     :count3points=> 0,
                     :count0points=> 10)
    user2 = User.new(:points => 46,
                     :count8points => 1,
                     :count5points => 1,
                     :count4points => 10,
                     :count3points => 0,
                     :count0points=> 9)

    user1_params = [user1.points,
                    user1.count8points,
                    user1.count5points,
                    user1.count4points,
                    user1.count3points]
    user2_params = [user2.points,
                    user2.count8points,
                    user2.count5points,
                    user2.count4points,
                    user2.count3points]

    user1_ranking_comparison_value = subject.send(:ranking_comparison_value, *user1_params)
    user2_ranking_comparison_value = subject.send(:ranking_comparison_value, *user2_params)

    expect(user1_ranking_comparison_value > user2_ranking_comparison_value).to be true
    expect(user1_ranking_comparison_value).to eq(4603040700)
    expect(user2_ranking_comparison_value).to eq(4601011000)
  end
end
