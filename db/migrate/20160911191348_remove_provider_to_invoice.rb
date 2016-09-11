class RemoveProviderToInvoice < ActiveRecord::Migration
  def change
    remove_reference :invoices, :provider
  end
end
