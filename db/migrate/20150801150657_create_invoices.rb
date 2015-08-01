class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :folio
      t.decimal :amount

      t.timestamps null: false
    end
  end
end
