class Invoice < ActiveRecord::Base
  has_one :purchase_order
  has_one :requisition, through: :purchase_order
  has_one :construction, through: :requisition
  belongs_to :payment
  belongs_to :invoice_receipt
  belongs_to :provider
end
