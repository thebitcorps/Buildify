class CreateBillingAdjustments < ActiveRecord::Migration
  def change
    create_table :billing_adjustments do |t|
      t.decimal :amount
      t.string :payment_type
      t.date :adjusment_date
      t.references :payment, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
