FactoryBot.define do
  factory :order do
    total { "9.99" }
    itbis { "9.99" }
    user { nil }
    state { "MyString" }
  end
end
