class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.integer :folio
      t.string :delivery_place
      t.string :delivery_address
      t.string :delivery_receiver
      t.string :status, default: 'pending'
      t.references :requisition, index: true, foreign_key: true
      t.references :invoice, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
