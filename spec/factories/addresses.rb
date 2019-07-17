FactoryBot.define do
  factory :address do
    address { "MyString" }
    user { nil }
    latitude { "9.99" }
    longitude { "9.99" }
  end
end
