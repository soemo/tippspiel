# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot/wiki/Usage

FactoryBot.define do
  factory :user do
    firstname { 'test' }
    sequence(:lastname) { |n| "user#{n}" }
    password { 'secret123' }
    password_confirmation { 'secret123' }
    sequence(:email) { |n| "test#{n}@tippspiel.de" }
    email_confirmation(&:email)
    points { 0 }
  end

  factory :active_user, parent: :user do
    confirmed_at { 1.minute.ago }
  end

  factory :active_admin, parent: :active_user do
    email { ADMIN_EMAIL }
  end
end
