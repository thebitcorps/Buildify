class CreateInvoiceReceipts < ActiveRecord::Migration
  def change
    create_table :invoice_receipts do |t|
      t.integer :folio
      t.string :status, default: 'empty'
      t.integer :receipt_date

      t.timestamps null: false
    end
  end
end
