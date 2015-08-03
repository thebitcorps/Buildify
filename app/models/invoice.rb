class Invoice < ActiveRecord::Base
  has_one :purchase_order
  has_one :requisition, through: :purchase_order
  has_one :construction, through: :requisition
  has_many :item_materials, through: :purchase_order
  belongs_to :provider
  belongs_to :expense
  belongs_to :invoice_receipt
end
