class AddReceiptReferencesToInvoice < ActiveRecord::Migration
  def change
    add_reference :invoices, :invoice_receipt, index: true, foreign_key: true
  end
end
