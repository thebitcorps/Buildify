class CreatePettyCashExpenses < ActiveRecord::Migration
  def change
    create_table :petty_cash_expenses do |t|
      t.string :concept
      t.string :amount
      t.date :expense_date
      t.text :observation
      t.references :petty_cash, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
