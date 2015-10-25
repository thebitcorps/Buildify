class CreateRequisitions < ActiveRecord::Migration
  def change
    create_table :requisitions do |t|
      t.integer :folio
      t.date :requisition_date
      t.string :status, default: 'pending'
      t.references :construction, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
