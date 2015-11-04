class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :folio
      t.string :status, default: 'waiting'
      t.decimal :amount
      t.date :invoice_date
      t.references :payment, index: true, foreign_key: true
      t.references :provider, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
