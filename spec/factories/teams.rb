# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "teamname#{n}" }
    sequence(:country_code) { |n| "country_code#{n}" }
  end
end
