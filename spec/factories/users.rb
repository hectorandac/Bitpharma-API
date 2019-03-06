FactoryBot.define do
  factory :user do
    id { Faker::IDNumber.valid }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at { Faker::Date.backward(1) }
  end
end
