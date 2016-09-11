class AddFormatedFolioToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :consecutive_folio, :integer
  end
end
