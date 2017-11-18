# -*- encoding : utf-8 -*-
FactoryBot.define do
  factory :team do
    sequence(:name){|n| "teamname#{n}" }
    sequence(:country_code){|n| "country_code#{n}" }
  end
end
