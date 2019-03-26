class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :barcode
      t.decimal :price, precision: 10, scale: 4
      t.decimal :selling_dose, precision: 10, scale: 4
      t.string :selling_unit

      t.timestamps
    end
  end
end
