class CreateAgainstReceipts < ActiveRecord::Migration
  def change
    create_table :against_receipts do |t|
      t.belongs_to :purchase_order, index: true, foreign_key: true
      t.belongs_to :invoice, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
