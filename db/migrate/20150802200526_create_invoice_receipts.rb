class CreateInvoiceReceipts < ActiveRecord::Migration
  def change
    create_table :invoice_receipts do |t|
      t.integer :folio
      t.references :provider, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
