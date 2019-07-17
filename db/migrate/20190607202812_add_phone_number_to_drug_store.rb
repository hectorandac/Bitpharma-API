class AddPhoneNumberToDrugStore < ActiveRecord::Migration[5.2]
  def change
    add_column :drug_stores, :phone_number, :string
  end
end
