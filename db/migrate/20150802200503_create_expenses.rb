class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :status
      t.decimal :amount_paid

      t.timestamps null: false
    end
  end
end
