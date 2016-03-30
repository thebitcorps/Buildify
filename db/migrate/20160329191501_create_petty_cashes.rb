class CreatePettyCashes < ActiveRecord::Migration
  def change
    create_table :petty_cashes do |t|
      t.date :closing_date
      t.references :construction, index: true, foreign_key: true
      t.string :amount

      t.timestamps null: false
    end
  end
end
