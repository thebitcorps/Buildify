class PurchaseOrder < ActiveRecord::Base
  has_many :item_materials
  belongs_to :invoice
  belongs_to :requisition
  belongs_to :provider
  has_one :construction, through: :requisition
  has_one :expense, through: :invoice
  has_one :invoice_receipt, through: :invoice

  accepts_nested_attributes_for :item_materials
end
