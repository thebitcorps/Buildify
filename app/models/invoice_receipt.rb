class InvoiceReceipt < ActiveRecord::Base
  belongs_to :provider
  has_many :invoices
end
