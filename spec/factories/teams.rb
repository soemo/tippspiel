FactoryGirl.define do
  factory :team do
    sequence(:name){|n| "teamname#{n}" }
  end
end