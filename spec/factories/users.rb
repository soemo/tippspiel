# -*- encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl/wiki/Usage

FactoryGirl.define do
  factory :user do
    firstname "test"
    lastname  "user"
    password  "test"
    password_confirmation {|u| u.password}
    sequence(:email){|n| "test#{n}@tippspiel.de" }
    points 0
  end
end
