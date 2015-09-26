class ItemMaterial < ActiveRecord::Base
  belongs_to :requisition
  belongs_to :purchase_order
  belongs_to :material
  has_one :invoice, through: :purchase_order
  has_one :construction, through: :requisition
  has_one :provider, through: :purchase_order
  has_one :invoice_receipt, through: :invoice
  has_one :payment, through: :invoice

  PARTIALLY_DELIVERED_STATUS = 'partially'
  DELIVERED_STATUS = 'delivered'
  AUTHORIZED_STATUS = 'authorized'
  PENDING_STATUS = 'pending'

  STATUS = [DELIVERED_STATUS,PENDING_STATUS,PARTIALLY_DELIVERED_STATUS,AUTHORIZED_STATUS]



end
