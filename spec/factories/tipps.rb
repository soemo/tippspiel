# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :tipp do
    association :user
    association :game
    team1_goals 0
    team2_goals 0
  end
end
