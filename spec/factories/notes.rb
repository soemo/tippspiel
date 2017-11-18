# -*- encoding : utf-8 -*-
FactoryBot.define do
  factory :notice do
    user { association :user, strategy: @build_strategy.class }
    sequence(:text){|n| "text bla blub #{n}" }
  end
end
