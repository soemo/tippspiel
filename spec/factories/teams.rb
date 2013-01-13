# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :team do
    sequence(:name){|n| "teamname#{n}" }
    sequence(:flag_image_url){|n| "flag_image_url#{n}" }
  end
end
