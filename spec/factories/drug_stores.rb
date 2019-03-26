# frozen_string_literal: true

FactoryBot.define do
  factory :drug_store do
    name { Faker::Company.name }
    description { Faker::Company.catch_phrase }
    user { create :user }
  end
end
