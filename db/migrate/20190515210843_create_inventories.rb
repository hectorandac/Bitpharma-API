class CreateInventories < ActiveRecord::Migration[5.2]
  def change
    create_table :inventories do |t|
      t.references :product, foreign_key: true
      t.references :drug_store, foreign_key: true
      t.integer :quantity
      t.decimal :sale_price, precision: 10, scale: 4

      t.timestamps
    end
  end
end
