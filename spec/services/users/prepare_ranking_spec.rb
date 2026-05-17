# frozen_string_literal: true

require 'rails_helper'

describe Users::PrepareRanking do
  subject { described_class }

  let(:user1) do
    User.new(id: 1,
             points: 8,
             count8points: 1,
             count5points: 0,
             count4points: 0,
             count3points: 0)
  end
  let(:user2) do
    User.new(id: 2,
             points: 8,
             count8points: 0,
             count5points: 1,
             count4points: 0,
             count3points: 1)
  end

  let(:user3) do
    User.new(id: 3,
             points: 12,
             count8points: 0,
             count5points: 1,
             count4points: 3,
             count3points: 0)
  end
  let(:user4) do
    User.new(id: 4,
             points: 12,
             count8points: 1,
             count5points: 0,
             count4points: 1,
             count3points: 0)
  end
  let(:user5) do
    User.new(id: 5,
             points: 12,
             count8points: 1,
             count5points: 0,
             count4points: 1,
             count3points: 0)
  end

  it 'prepares the ranking' do
    users = [user4, user5, user3, user1, user2]
    expected = {
      1 => [user4, user5],
      3 => [user3],
      4 => [user1],
      5 => [user2]
    }
    expect(subject.call(users_for_ranking: users)).to eq(expected)
  end
end
