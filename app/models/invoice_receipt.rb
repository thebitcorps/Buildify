class InvoiceReceipt < ActiveRecord::Base
  has_many :invoices
  has_many :payments, through: :invoices
  has_many :purchase_orders, through: :invoices
  has_many :requisitions, through: :purchase_orders
end
