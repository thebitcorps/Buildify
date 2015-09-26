class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :status
      t.string :consept
      t.decimal :amount
      t.date :payment_date
      t.decimal :paid_amount, defaul: 0.0
      t.references :construction, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
