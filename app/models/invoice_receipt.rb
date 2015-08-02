class InvoiceReceipt < ActiveRecord::Base
  has_many :invoices
end
