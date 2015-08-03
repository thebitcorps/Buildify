class PurchaseOrder < ActiveRecord::Base
  has_many :item_materials
  belongs_to :invoice
  has_one :provider, through: :invoice
  has_one :expense, through: :invoice
  has_one :invoice_receipt, through: :invoice

  accepts_nested_attributes_for :item_materials

  def requisition
    item_materials.first.requisition if !item_materials.blank?
  end

  def construction
    requisition.construction if requisition
  end

end
