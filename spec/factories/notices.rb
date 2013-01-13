# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :notice do
    association :user
    sequence(:text){|n| "text bla blub #{n}" }
  end
end
