class AddReceiptFolioToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :receipt_folio, :string
  end
end
