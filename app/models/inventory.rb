class Inventory < ApplicationRecord
  belongs_to :product
  belongs_to :drug_store

  def sanitazed_info
    {
        product: ::Product.find(product_id),
        drug_store: ::DrugStore.find(drug_store_id),
        quantity: quantity,
        sale_price: sale_price,
    }
  end
end
