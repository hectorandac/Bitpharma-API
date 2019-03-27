class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.decimal :total, precision: 10, scale: 4
      t.decimal :itbis, precision: 10, scale: 4
      t.references :user, foreign_key: true
      t.string :state

      t.timestamps
    end
  end
end
