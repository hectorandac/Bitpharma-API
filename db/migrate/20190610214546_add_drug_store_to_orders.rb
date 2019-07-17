class AddDrugStoreToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :drug_store, foreign_key: true
  end
end
