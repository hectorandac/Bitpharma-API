class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :address
      t.references :user, foreign_key: true
      t.decimal :latitude, precision: 12, scale: 6
      t.decimal :longitude, precision: 12, scale: 6

      t.timestamps
    end
  end
end
