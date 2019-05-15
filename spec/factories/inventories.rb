FactoryBot.define do
  factory :inventory do
    product { nil }
    drug_store { nil }
    quantity { 1 }
    sale_price { "9.99" }
  end
end
