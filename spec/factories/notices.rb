FactoryGirl.define do
  factory :notice do
    association :user
    sequence(:text){|n| "text bla blub #{n}" }
  end
end