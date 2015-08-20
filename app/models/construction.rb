class Construction < ActiveRecord::Base
  has_many :requisitions
  has_many :purchase_orders, through: :requisitions
  has_many :invoices, through: :purchase_orders
  has_many :invoice_receipts, through: :invoices
  has_many :payments
  has_many :invoiced_payments, through: :invoices, source: :payment
end
