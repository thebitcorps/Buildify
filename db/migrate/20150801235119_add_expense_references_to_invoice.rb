class AddExpenseReferencesToInvoice < ActiveRecord::Migration
  def change
    add_reference :invoices, :expense, index: true, foreign_key: true
  end
end
