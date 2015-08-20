class CreateInvoiceReceipts < ActiveRecord::Migration
  def change
    create_table :invoice_receipts do |t|
      t.integer :folio
      t.integer :receipt_date

      t.timestamps null: false
    end
  end
end
