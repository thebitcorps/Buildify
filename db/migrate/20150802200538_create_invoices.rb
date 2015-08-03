class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :folio
      t.decimal :amount
      t.references :invoice_receipt, index: true, foreign_key: true
      t.references :expense, index: true, foreign_key: true
      t.references :provider, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
