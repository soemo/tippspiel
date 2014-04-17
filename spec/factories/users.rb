# -*- encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl/wiki/Usage

FactoryGirl.define do
  factory :user do
    firstname 'test'
    sequence(:lastname){|n| "user#{n}" }
    password  'secret123'
    password_confirmation 'secret123'
    sequence(:email){|n| "test#{n}@tippspiel.de" }
    points 0
  end

  factory :active_user, parent => :user do
     confirmed_at Time.now
   end
end
