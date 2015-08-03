class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :concept
      t.string :status
      t.decimal :amount_paid
      t.string :check_number

      t.timestamps null: false
    end
  end
end
