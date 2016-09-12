class CreateEstimates < ActiveRecord::Migration
  def change
    create_table :estimates do |t|
      estimates_amountt.decimal :amount
      t.date :payment_date
      t.references :construction, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
