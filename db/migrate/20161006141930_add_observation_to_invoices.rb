class AddObservationToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :observations, :text ,default: ''
  end
end
