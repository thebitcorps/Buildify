class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :status
      t.string :consept
      t.date :payment_date
      t.references :construction, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
