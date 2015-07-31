class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.integer :folio
      t.string :delivery_place
      t.string :delivery_address
      t.string :delivery_receiver

      t.timestamps null: false
    end
  end
end
