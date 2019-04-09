class CreateJoinTableProductsUsers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :products, :users do |t|
      # t.index [:product_id, :user_id]
      # t.index [:user_id, :product_id]
    end
  end
end
