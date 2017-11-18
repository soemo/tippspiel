# -*- encoding : utf-8 -*-
FactoryBot.define do
  factory :tip do
    user { association :user, strategy: @build_strategy.class }
    game { association :game, strategy: @build_strategy.class }
    team1_goals 0
    team2_goals 0
  end
end
