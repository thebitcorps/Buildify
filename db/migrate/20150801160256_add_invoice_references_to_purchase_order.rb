class AddInvoiceReferencesToPurchaseOrder < ActiveRecord::Migration
  def change
    add_reference :purchase_orders, :invoice, index: true, foreign_key: true
  end
end
