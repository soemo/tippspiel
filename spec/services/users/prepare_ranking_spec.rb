# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Users::PrepareRanking do

  subject { Users::PrepareRanking }

  let(:user1) {User.new(id: 1,
                        points: 8,
                        count8points: 1,
                        count5points: 0,
                        count4points: 0,
                        count3points: 0)}
  let(:user2) {User.new(id: 2,
                        points: 8,
                        count8points: 0,
                        count5points: 1,
                        count4points: 0,
                        count3points: 1)}

  let(:user3) {User.new(id: 3,
                        points: 12,
                        count8points: 0,
                        count5points: 1,
                        count4points: 3,
                        count3points: 0)}
  let(:user4) {User.new(id: 4,
                        points: 12,
                        count8points: 1,
                        count5points: 0,
                        count4points: 1,
                        count3points: 0)}
  let(:user5) {User.new(id: 5,
                        points: 12,
                        count8points: 1,
                        count5points: 0,
                        count4points: 1,
                        count3points: 0)}


  it 'prepares the ranking' do
    users = [user4, user5, user3, user1, user2]
    expected = {
        1 => [user4, user5],
        3 => [user3],
        4 => [user1],
        5 => [user2],
    }
    expect(subject.call(users_for_ranking: users)).to eq(expected)
  end

end