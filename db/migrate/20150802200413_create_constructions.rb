class CreateConstructions < ActiveRecord::Migration
  def change
    create_table :constructions do |t|
      t.string :title
      t.date :start_date
      t.date :finish_date
      t.decimal :contract_amount
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
