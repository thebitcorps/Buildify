class CreateExtensions < ActiveRecord::Migration
  def change
    create_table :extensions do |t|
      t.date :date
      t.belongs_to :construction, index: true, foreign_key: true
      t.decimal :amount

      t.timestamps null: false
    end
  end
end
