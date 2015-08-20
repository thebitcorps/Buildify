class PurchaseOrder < ActiveRecord::Base
  has_many :item_materials
  belongs_to :invoice
  belongs_to :requisition
  has_one :provider, through: :invoice
  has_one :construction, through: :requisition
  has_one :apyment, through: :invoice
  has_one :invoice_receipt, through: :invoice
end
