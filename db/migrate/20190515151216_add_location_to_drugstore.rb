class AddLocationToDrugstore < ActiveRecord::Migration[5.2]
  def change
    add_column :drug_stores, :latitude, :decimal
    add_column :drug_stores, :longitude, :decimal
  end
end
