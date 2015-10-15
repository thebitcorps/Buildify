class ItemMaterial < ActiveRecord::Base
  belongs_to :requisition
  belongs_to :purchase_order
  belongs_to :material
  has_one :invoice, through: :purchase_order
  has_one :construction, through: :requisition
  has_one :provider, through: :purchase_order
  has_one :invoice_receipt, through: :invoice
  has_one :payment, through: :invoice

  validates :requested, numericality: true

  PARTIALLY_DELIVERED_STATUS = 'partially'
  DELIVERED_STATUS = 'delivered'
  AUTHORIZED_STATUS = 'authorized'
  MISSED_STATUS = 'missed'
  PENDING_STATUS = 'pending'

  STATUS = [DELIVERED_STATUS,PENDING_STATUS,PARTIALLY_DELIVERED_STATUS,AUTHORIZED_STATUS]


  # def update_purchase_order_status
  #   return unless purchase_order
  #   for item_material in purchase_order.item_materials
  #     if
  #   end
  # end


end
