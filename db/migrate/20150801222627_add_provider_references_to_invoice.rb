class AddProviderReferencesToInvoice < ActiveRecord::Migration
  def change
    add_reference :invoices, :provider, index: true, foreign_key: true
  end
end
